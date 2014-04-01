From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/iser: Bump driver version to 1.3
Date: Tue, 1 Apr 2014 21:42:00 +0300
Message-ID: <CAJZOPZ+jdiiiSwguoBigG53PCc-hJehJaKPWxrTzGd_pFh6hww@mail.gmail.com>
References: <1396358344-15191-1-git-send-email-ogerlitz@mellanox.com>
	<1396358344-15191-5-git-send-email-ogerlitz@mellanox.com>
	<2807E5FD2F6FDA4886F6618EAC48510E04B37325@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E04B37325-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 1, 2014 at 8:05 PM, Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h
>> b/drivers/infiniband/ulp/iser/iscsi_iser.h
>> index a4e4876..324129f 100644
>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.h
>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
>> @@ -69,7 +69,7 @@
>>
>>  #define DRV_NAME     "iser"
>>  #define PFX          DRV_NAME ": "
>> -#define DRV_VER              "1.1"
>> +#define DRV_VER              "1.3"
>
> Not that it matters much but it seems odd to go from 1.1 to 1.3...

Indeed, but that's where we are... we have an internal version which
went through v1.2 in a manner unnoticed by the upstream one... but now
we're in sync, so
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
