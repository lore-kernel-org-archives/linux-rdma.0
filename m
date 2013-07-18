From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Thu, 18 Jul 2013 17:06:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805B97AC@ORSMSX109.amr.corp.intel.com>
References: <1372873336-13694-1-git-send-email-ogerlitz@mellanox.com>
 <1372873336-13694-4-git-send-email-ogerlitz@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373805B9484@ORSMSX109.amr.corp.intel.com>
 <51E8001B.5000506@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E8001B.5000506-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> +	kern_spec = kern_flow_attr + 1;
> >> +	ib_spec = flow_attr + 1;
> >> +	for (i = 0; i < flow_attr->num_of_specs; i++) {
> >> +		err = kern_spec_to_ib_spec(kern_spec, ib_spec);
> >> +		if (err)
> >> +			goto err_free;
> >> +		flow_attr->size +=
> >> +			((struct _ib_flow_spec *)ib_spec)->size;
> >> +		kern_spec += ((struct ib_kern_spec *)kern_spec)->size;
> >> +		ib_spec += ((struct _ib_flow_spec *)ib_spec)->size;
> > I didn't see where the ib_kern_spec size field was validated.  Maybe add this
> check to kern_spec_to_ib_spec?
> It wasn't validated. The function could be written in a more secured
> way. Meaning, we should only loop until we met flow_attr->num_of_specs
> or we exhausted all the bytes we copied from the user.
> Furthermore, as you said, it'll be more secured to add a new check in
> kern_spec_to_ib_spec that verifies that the size that the user sent
> matches the size of the kernel's struct.

It needs to be validated, otherwise the code above will walk off into random memory.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
