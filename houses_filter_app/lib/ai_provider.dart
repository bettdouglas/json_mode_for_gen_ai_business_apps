import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

Future<Map<String, dynamic>> filtersFromLLM(String query) async {
  final chatModel = ChatOpenAI(
    apiKey: '---',
    defaultOptions: ChatOpenAIOptions(
      temperature: 1.6,
      model: 'gpt-4o-mini-2024-07-18',
      responseFormat: ChatOpenAIResponseFormat.jsonSchema(
        ChatOpenAIJsonSchema(
          name: 'HouseFilters',
          description: 'Set of house filters',
          strict: true,
          schema: schema,
        ),
      ),
    ),
  );
  final prompt = ChatPromptTemplate.fromPromptMessages(
    [
      ChatMessagePromptTemplate.system("""
You're a housing data assistant. 
You will generate filters matching from a user's query.
If a filter is not requested, set the field as null. 
"""),
      ChatMessagePromptTemplate.human('{query}'),
    ],
  );

  final chain = prompt.pipe(chatModel).pipe(JsonOutputParser());
  final response = await chain.invoke({'query': query});

  for (var entry in response.entries) {
    if (entry.value == 'unspecified') {
      response[entry.key] = null;
    }
  }

  return response..removeWhere((key, value) => value == null);
}

final schema = {
  "type": "object",
  "properties": {
    "minPrice": {
      "type": ["integer", "null"],
      "description":
          "The minimum price of the listing. Can be an integer value representing the price in a specific currency or null if no price filter is applied."
    },
    "maxPrice": {
      "type": ["integer", "null"],
      "description":
          "The maximum price of the listing. Can be an integer value representing the price in a specific currency or null if no price filter is applied."
    },
    "minArea": {
      "type": ["integer", "null"],
      "description":
          "The minimum area of the listing. Can be an integer value representing the area in square feet or null if no area filter is applied."
    },
    "maxArea": {
      "type": ["integer", "null"],
      "description":
          "The maximum area of the listing. Can be an integer value representing the area in square feet or null if no area filter is applied."
    },
    "bedrooms": {
      "type": ["integer", "null"],
      "description":
          "The number of bedrooms in the listing. Can be an integer value representing the number of bedrooms or null if no bedroom filter is applied."
    },
    "minBedrooms": {
      "type": ["integer", "null"],
      "description":
          "The minimum number of bedrooms in the listing. Can be an integer value representing the number of bedrooms or null if no bedroom filter is applied."
    },
    "maxBedrooms": {
      "type": ["integer", "null"],
      "description":
          "The maximum number of bedrooms in the listing. Can be an integer value representing the number of bedrooms or null if no bedroom filter is applied."
    },
    "bathrooms": {
      "type": ["integer", "null"],
      "enum": [1, 2, 3, 4],
      "description":
          "The number of bathrooms in the listing. Can be an integer value of 1, 2, 3, or 4, or null if no bathroom filter is applied."
    },
    "minStories": {
      "type": ["integer", "null"],
      "description":
          "The minimum number of stories in the listing. Can be an integer value representing the number of stories or null if no story filter is applied."
    },
    "maxStories": {
      "type": ["integer", "null"],
      "description":
          "The maximum number of stories in the listing. Can be an integer value representing the number of stories or null if no story filter is applied."
    },
    "mainroad": {
      "type": ["string", "null"],
      "enum": ["yes", "no", "unspecified"],
      "description":
          "Whether the listing has a main road access. Can be a string value of 'yes' or 'no', or null if no filter is applied for this amenity."
    },
    "guestroom": {
      "type": ["string", "null"],
      "enum": ["yes", "no", "unspecified"],
      "description":
          "Whether the listing has a guest room. Can be a string value of 'yes' or 'no', or null if no filter is applied for this amenity."
    },
    "basement": {
      "type": ["string", "null"],
      "enum": ["yes", "no", "unspecified"],
      "description":
          "Whether the listing has a basement. Can be a string value of 'yes' or 'no', or null if no filter is applied for this amenity."
    },
    "hotwaterheating": {
      "type": ["string", "null"],
      "enum": ["yes", "no", "unspecified"],
      "description":
          "Whether the listing has hot water heating. Can be a string value of 'yes' or 'no', or null if no filter is applied for this amenity."
    },
    "airconditioning": {
      "type": ["string", "null"],
      "enum": ["yes", "no", "unspecified"],
      "description":
          "Whether the listing has air conditioning. Can be a string value of 'yes' or 'no', or null if no filter is applied for this amenity."
    },
    "minParking": {
      "type": ["integer", "null"],
      "description":
          "The minimum number of parking spaces in the listing. Can be an integer value representing the number of parking spaces or null if no parking filter is applied."
    },
    "maxParking": {
      "type": ["integer", "null"],
      "description":
          "The maximum number of parking spaces in the listing. Can be an integer value representing the number of parking spaces or null if no parking filter is applied."
    },
    "prefarea": {
      "type": ["string", "null"],
      "enum": ["yes", "no", "unspecified"],
      "description":
          "Whether the listing is in a preferred area. Can be a string value of 'yes' or 'no', or null if no filter is applied for this amenity."
    },
    "furnishingstatus": {
      "type": ["string", "null"],
      "enum": ["furnished", "semi-furnished", "unfurnished", "unspecified"],
      "description":
          "The furnishing status of the listing. Can be a string value of 'furnished', 'semi-furnished', or 'unfurnished', or null if no furnishing status filter is applied."
    }
  },
  "additionalProperties": false,
  "required": [
    'minPrice',
    'maxPrice',
    'minArea',
    'maxArea',
    'minBedrooms',
    'maxBedrooms',
    'bathrooms',
    'minStories',
    'maxStories',
    'minParking',
    'maxParking',
    'mainroad',
    'guestroom',
    'basement',
    'hotwaterheating',
    'airconditioning',
    'prefarea',
    'furnishingstatus',
    'bedrooms',
  ],
  "description":
      "A JSON schema for filtering real estate listings based on various properties."
};

// Look for houses, 
// near this place
// With 2 bathrooms
// And a mainroad
// And a guest room
// And hot waterheating. 