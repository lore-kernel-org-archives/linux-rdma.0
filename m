From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Fri, 23 Sep 2016 11:06:55 +0300
Message-ID: <20160923080655.GM4088@leon.nu>
References: <20160923041340.GA11269@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x38akuY2VS0PywU3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160923041340.GA11269-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--x38akuY2VS0PywU3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 22, 2016 at 10:13:40PM -0600, Jason Gunthorpe wrote:
> Upon deeper analysis it seems there are two variations of the 'OpenIB.org BSD
> license', I am calling them the MIT and FreeBSD variants. They differ only in
> the text of the disclaimer. The MIT version is used widely as the source
> license so that version should be the 'default' in the source tree, not the
> FreeBSD version I had selected initially.
>
> Retain the FreeBSD version as we will refer to it in future commits.
>
> Elaborate the COPYING file to discuss the license situation in
> more depth.

I doubt that we have appropriate knowledge to come into meaningful
conclusion after "discussion". It is legal issue which should be
handled by relevant legal departments.

>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  COPYING         |  6 ------
>  COPYING.BSD     | 26 ----------------------
>  COPYING.BSD_FB  | 22 +++++++++++++++++++
>  COPYING.BSD_MIT | 20 +++++++++++++++++
>  COPYING.md      | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 109 insertions(+), 32 deletions(-)
>  delete mode 100644 COPYING
>  delete mode 100644 COPYING.BSD
>  create mode 100644 COPYING.BSD_FB
>  create mode 100644 COPYING.BSD_MIT
>  create mode 100644 COPYING.md
>
> I have reviewed most of the files now for copyright considerations to
> make sure our licensing is in order.
>
> This is my proposal for the top level COPYING file, and it contains a
> summary of my findings on licensing.
>
> Due to various mistakes in the past things are overly complex, I would
> appreciate any patches to reduce the complexity. eg ensuring that all
> files have a license reference and the removal of the sub dir COPYING
> files.
>
> It would be appreciated if those who hold the copyrights can adjust
> their licenses to match the so-called 'Default Dual License', eg by
> patching the remaining COPYING files to use the correct disclaimer.
>
> Here is my first jab at simplifying:
>
> https://github.com/jgunthorpe/rdma-plumbing/commit/079d840b102906c79ff07b7fe9d5db6bba26517c
>
> diff --git a/COPYING b/COPYING
> deleted file mode 100644
> index ac58180e900c..000000000000
> --- a/COPYING
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -Unless otherwise stated this software is available to you under a choice of
> -one of two licenses.  You may choose to be licensed under the terms of the the
> -OpenIB.org BSD license (see COPYING.BSD) or the GNU General Public License
> -(GPL) Version 2 (see COPYING.GPL2), both included in this package.
> -
> -Refer to individual files for information on the copyright holders.
> diff --git a/COPYING.BSD b/COPYING.BSD
> deleted file mode 100644
> index 59b3a397a13b..000000000000
> --- a/COPYING.BSD
> +++ /dev/null
> @@ -1,26 +0,0 @@
> -		       OpenIB.org BSD license
> -
> -Redistribution and use in source and binary forms, with or without
> -modification, are permitted provided that the following conditions
> -are met:
> -
> -  * Redistributions of source code must retain the above copyright
> -    notice, this list of conditions and the following disclaimer.
> -
> -  * Redistributions in binary form must reproduce the above
> -    copyright notice, this list of conditions and the following
> -    disclaimer in the documentation and/or other materials provided
> -    with the distribution.
> -
> -THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> -"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> -LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> -FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> -COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
> -INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
> -BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> -LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
> -CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> -LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
> -ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> -POSSIBILITY OF SUCH DAMAGE.
> diff --git a/COPYING.BSD_FB b/COPYING.BSD_FB
> new file mode 100644
> index 000000000000..44237612faa3
> --- /dev/null
> +++ b/COPYING.BSD_FB
> @@ -0,0 +1,22 @@
> +		   OpenIB.org BSD license (FreeBSD Variant)
> +
> +Redistribution and use in source and binary forms, with or without
> +modification, are permitted provided that the following conditions are met:
> +
> +  - Redistributions of source code must retain the above copyright notice,
> +    this list of conditions and the following disclaimer.
> +
> +  - Redistributions in binary form must reproduce the above copyright notice,
> +    this list of conditions and the following disclaimer in the documentation
> +    and/or other materials provided with the distribution.
> +
> +THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> +AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> +IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> +DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
> +FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> +DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> +SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
> +CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
> +OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> +OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> diff --git a/COPYING.BSD_MIT b/COPYING.BSD_MIT
> new file mode 100644
> index 000000000000..a1432b6134e6
> --- /dev/null
> +++ b/COPYING.BSD_MIT
> @@ -0,0 +1,20 @@
> +		     OpenIB.org BSD license (MIT variant)
> +
> +Redistribution and use in source and binary forms, with or without
> +modification, are permitted provided that the following conditions are met:
> +
> +  - Redistributions of source code must retain the above copyright notice,
> +    this list of conditions and the following disclaimer.
> +
> +  - Redistributions in binary form must reproduce the above copyright notice,
> +    this list of conditions and the following disclaimer in the documentation
> +    and/or other materials provided with the distribution.
> +
> +THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> +IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> +FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> +AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> +LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> +OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> +SOFTWARE.
> +
> diff --git a/COPYING.md b/COPYING.md
> new file mode 100644
> index 000000000000..edcb01af9954
> --- /dev/null
> +++ b/COPYING.md
> @@ -0,0 +1,67 @@
> +# Default Dual License
> +
> +Unless otherwise stated this software is available to you under a choice of
> +one of two licenses.  You may choose to be licensed under the terms of the the
> +OpenIB.org BSD (MIT variant) license (see COPYING.BSD_MIT) or the GNU General
> +Public License (GPL) Version 2 (see COPYING.GPL2), both included in this
> +package.
> +
> +Files marked 'See COPYING file' are licensed under the above Dual License.
> +
> +# Other Options
> +
> +Individual source files may use a license different from the above Defaul Dual
> +License. If a license is declared in the file then it supersedes the Default
> +License.
> +
> +If a directory contains a COPYING file then the License from that file becomes
> +the Default License for files in that directory and below.
> +
> +# Copyright Holders
> +
> +Refer to individual files for information on the copyright holders.
> +
> +# License Catalog (Informative, Non Binding)
> +
> +## Providers
> +
> +The following providers use a different license than the Default Dual
> +License. Refer to files in each directory for details.
> +
> +cxbg4
> +: A combination of the
> +    - Default Dual License
> +    - cxgb4/src/queue.h: BSD 3 clause license.
> +
> +hfi1verbs
> +: Dual License: GPLv2 or Intel 3 clause BSD license
> +
> +ipathverbs
> +: Dual License: GPLv2 or PathScale BSD Patent license
> +
> +ocrdma
> +: Dual License: GPLv2 or OpenIB.org BSD (FreeBSD variant), See COPYING.BSD_FB
> +
> +rxe
> +: A combination of the
> +    - Default Dual License
> +    - GPLv2 or PathScale BSD Patent license
> +
> +## Libraries
> +
> +All library compilable source code (.c and .h files) are available under the
> +Default Dual License.
> +
> +Unmarked ancillary files may be available under a Dual License: GPLv2 or
> +OpenIB.org BSD (FreeBSD variant).
> +
> +## Tools (iwpmd, srp_deamon, ibacm)
> +
> +All compilable source code (.c and .h files) are available under the Default
> +Dual License.
> +
> +Unmarked ancillary files may be available under a Dual License: GPLv2 or
> +OpenIB.org BSD (FreeBSD variant).
> +
> +srp_daemon/srp_daemon/srp_daemon.sh: Any one of the GPLv2, a 2 clause BSD
> +license or the CPLv1.
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--x38akuY2VS0PywU3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX5OKfAAoJEORje4g2clinfWoQAJ6cTGEzCF0RKfOLQyE5PWoh
Hz63EYdDlPJGOyuRUOu0EX7SFa0nByPrYArsadvKWIBV/EfhuTw8b77QaiNkD++W
Ea1SDQ4pOJxXQKBz4zT93IjUGtRcFDDnxC6dMfjH2y8ps0vRCsJMIG7g1oEVs85k
EH8Xh6laRcb2gPS8V8Ti1AeLAo2qKZd5my0tMNCFEKk7LpaWMvZkG9R1kJson1/G
wX4+9NzlTV0FBChRPRsLd/sVJ7UITlibMEd9RxpnE/p7dJj6j3q6zmkYS++DE1L/
eE/WOKPVbNjFFHkySEFj1IG/yzVJUndoPOe19/kAsJWrI/f9o6zF+GV41jOIkiyM
/r//49yNMmVPaFRuOnQ9eAmJ4GeMhVJoHpPkPbEPB7+BgAsQHvvwnR/HStbKwUV0
zy7nWcKH4bdky//FJlchcdp0quxgtpcSGBnLuMsMxnSD9EA9Rz3iro1kUBKhHice
kaBP7RmMktFCEUTzBUeW2+0x8hIPgH7oI0u2SHTS8fi6eA7hcCH+7T09iKQnxXxs
P3p6oO2FL4rYuwygpdLhsJeb6c7m2nUdUGxYodWr+9LTWVjH72099lDEymoKYCMQ
f2t/kZXP2qJAnelCDnLxj0ec4XBxe0cRbvMj1ekC0hbedJwDJPIgfOb0bT9UOjH4
e4Y3AMnXdmGb8gFBSyWg
=E1nW
-----END PGP SIGNATURE-----

--x38akuY2VS0PywU3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
