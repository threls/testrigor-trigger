# TestRigor Test Suite Trigger Action

[![Version](https://img.shields.io/badge/version-v1-blue.svg)](https://github.com/threls/testrigor-trigger-action/releases/tag/v1)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This GitHub Action triggers a TestRigor test suite execution via the TestRigor API.

## Prerequisites

- A TestRigor account
- A TestRigor API token
- A Test Suite Key from TestRigor

## Usage

Add the following to your GitHub Actions workflow:

```yaml
- name: Run TestRigor Suite
  uses: threls/testrigor-trigger-action@v1
  env:
    TESTRIGOR_TOKEN: ${{ secrets.TESTRIGOR_TOKEN }}
    TEST_SUITE_KEY: ${{ secrets.TEST_SUITE_KEY }}
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `TESTRIGOR_TOKEN` | Your TestRigor API authentication token | Yes |
| `TEST_SUITE_KEY` | The unique identifier for your test suite | Yes |

## Outputs

When successful, the action will output:
- The execution ID of the triggered test suite
- A URL where you can monitor the test execution progress

## Example Workflow

```yaml
name: TestRigor Test Suite

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Run TestRigor Suite
        uses: threls/testrigor-trigger-action@v1
        env:
          TESTRIGOR_TOKEN: ${{ secrets.TESTRIGOR_TOKEN }}
          TEST_SUITE_KEY: ${{ secrets.TEST_SUITE_KEY }}
```

## Error Handling

The action will fail if:
- Required environment variables are not set
- The API request fails
- The response from TestRigor is invalid
- No execution ID is returned from TestRigor

## Security

Store your TestRigor token as a GitHub repository secret. Never commit these values directly in your workflow files.

The test suite key can be stored as a variable, otherwise the execution urls will not work as they will be hidden from the output.

## Contributing

Feel free to open issues or submit pull requests if you find any problems or have suggestions for improvements.

## License

MIT License

Copyright (c) 2024 Threls

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.