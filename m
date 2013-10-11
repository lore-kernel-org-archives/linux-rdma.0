From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] iblinkinfo: Remove "-R" option from man page
Date: Fri, 11 Oct 2013 00:52:35 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E047B2EBD@CRSMSX101.amr.corp.intel.com>
References: <20131010142112.GA22757@r-ufm5-17.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131010142112.GA22757-Kyg1NGsloJ8bMuq+TCmafCexzy7lsfyC@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Dan Ben Yosef [mailto:danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Thursday, October 10, 2013 7:21 AM
> To: Weiny, Ira
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] iblinkinfo: Remove "-R" option from man page
> 
> remove "-R" option from iblinkinfo man
> 
> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira


> ---
>  doc/man/iblinkinfo.8.in     |    1 -
>  doc/rst/iblinkinfo.8.in.rst |    2 --
>  src/iblinkinfo.c            |    2 --
>  3 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/doc/man/iblinkinfo.8.in b/doc/man/iblinkinfo.8.in index
> cf7aad7..7f89ec5 100644
> --- a/doc/man/iblinkinfo.8.in
> +++ b/doc/man/iblinkinfo.8.in
> @@ -244,7 +244,6 @@ May be used several times (\-vv or \-v \-v \-v)  .sp
>  \fB\-V, \-\-version\fP     show the version info.
>  .sp
> -\fB\-R\fP (This option is obsolete and does nothing)  .SH EXIT STATUS  .sp
>  0 on success, \-1 on failure to scan the fabric, 1 if check mode is used and diff
> --git a/doc/rst/iblinkinfo.8.in.rst b/doc/rst/iblinkinfo.8.in.rst index
> bfdaada..ee2aefb 100644
> --- a/doc/rst/iblinkinfo.8.in.rst
> +++ b/doc/rst/iblinkinfo.8.in.rst
> @@ -109,8 +109,6 @@ Debugging flags
>  .. include:: common/opt_v.rst
>  .. include:: common/opt_V.rst
> 
> -**-R** (This option is obsolete and does nothing)
> -
>  EXIT STATUS
>  ===========
> 
> diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c index deffbd1..92ff3c6 100644
> --- a/src/iblinkinfo.c
> +++ b/src/iblinkinfo.c
> @@ -629,8 +629,6 @@ int main(int argc, char **argv)
>  		 "Output only switches"},
>  		{"cas-only", 7, 0, NULL,
>  		 "Output only CAs"},
> -		{"GNDN", 'R', 0, NULL,
> -		 "(This option is obsolete and does nothing)"},
>  		{0}
>  	};
>  	char usage_args[] = "";
> --
> 1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
