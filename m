From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/cm: check that idr_pre_get didn't fail and clean
 it in error flow
Date: Thu, 3 Nov 2011 13:52:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8CCD4@ORSMSX101.amr.corp.intel.com>
References: <201111031519.48018.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201111031519.48018.dotanb-g2bIKuvJtcQanlnWow0HJg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The function idr_pre_get may fail, so there is a need to check the status of
> it. Since this function allocate resources, we need to clean them during the
> resource cleaning in case of error.

We should add the cleanup code below, but I don't think we care if idr_pre_get fails here.  We'll just try again later.

> -error2:
> +error3:
>  	destroy_workqueue(cm.wq);
> -error1:
> +error2:
>  	class_unregister(&cm_class);
> +error1:
> +	idr_destroy(&cm.local_id_table);
>  	return ret;
>  }
> 

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
