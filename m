From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 rdma-next 7/8] IB/core: Move opa_class_port_info
 definition to header file
Date: Fri, 28 Apr 2017 18:44:27 -0400
Message-ID: <1493419467.3041.172.camel@redhat.com>
References: <1493416031-23917-1-git-send-email-dasaratharaman.chandramouli@intel.com>
         <1493416031-23917-8-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493416031-23917-8-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-04-28 at 17:47 -0400, Dasaratharaman Chandramouli wrote:
> Both opa_vnic and the hfi driver use the same opa_classport_info
> definition. We will also have ib_sa capable of querying opa class
> port info and would need this definition. Move it to ib_mad.h
> for everyone to use.
> 
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramou
> li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

I applied this one.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
