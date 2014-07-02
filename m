From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] ibacm: define prov_lib_path as a char array
Date: Wed, 2 Jul 2014 20:22:21 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04BD17C0@CRSMSX101.amr.corp.intel.com>
References: <1404325850-918-1-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404325850-918-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> diff --git a/src/acm.c b/src/acm.c
> index 8f147ef..fae9d0b 100644
> --- a/src/acm.c
> +++ b/src/acm.c
> @@ -193,7 +193,7 @@ static int log_level = 0;  static char lock_file[128] =
> "/var/run/ibacm.pid";  static short server_port = 6125;  static int
> support_ips_in_addr_cfg = 0; -static char *prov_lib_path = IBACM_LIB_PATH;
> +static char prov_lib_path[256] = IBACM_LIB_PATH;

256 is too short for a path.  Typical is 4096 but would be nice if it were dynamic.

Ira


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
