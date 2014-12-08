From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 03/16] ib/mad: Add check for jumbo MADs support on a device
Date: Mon, 8 Dec 2014 13:29:07 +0200
Message-ID: <CAJ3xEMj-0_0F+VoGZDes92ShFRTbt9Et4WWPt=viY5gx_P-oNg@mail.gmail.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
	<1415908465-24392-4-git-send-email-ira.weiny@intel.com>
	<54770F44.2090909@mellanox.com>
	<2807E5FD2F6FDA4886F6618EAC48510E0CBD4F23@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBD4F23-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 8, 2014 at 2:23 AM, Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> I find it very annoying that upper level drivers replicate in different ways
>> elements from the IB device attributes returned by ib_query_device. I met that
>> in multiple drivers and upcoming designs for which I do code review. Are you
>> up to come up with a patch that caches the device attributes on the device
>> structure?

> I don't follow what you are asking for.  Could you give more details?

1. add a struct ib_device_attr field to struct ib_device

2. when the device registers itself with the IB core, go and run the
query_device verb with the param being pointer to that field
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
