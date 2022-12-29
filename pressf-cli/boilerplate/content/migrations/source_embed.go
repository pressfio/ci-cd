// you can redefine Source variable with migrations' sources you want.
//

package migrations

import "embed"

//go:embed *
var Source embed.FS
