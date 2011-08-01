From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Mon, 1 Aug 2011 15:08:06 +0300
Message-ID: <201108011508.06521.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com> <BANLkTimwTs4EK19PiTq6yMzPCQrLt0bALw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A823730218F4@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823730218F4-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 16 June 2011 22:27, Hefty, Sean wrote:
> > Basically, I wasn't referring to such new verbs as vendor extensions,
> > but rather as new verbs we want to add at this and/or future points of
> > time which didn't exist at the time the IB stack and specifically its
> > kernel/user ABIs/APIs were written (couple of years ago...).
> 
> To be clear, there are 2 sides to ibverbs - the app side, and the provider library.
> 
> On the app side, new functionality would be added directly to libibverbs.  I would reuse what's there if possible, and provide direct API calls where needed.  For example, the xrc patch adds:
> 
> ibv_create_xsrq()
> ibv_open_xrcd()
> ibv_close_xrcd()
> 
> as new APIs.  On the provider side, the necessary calls are obtained by ibverbs calling get_ext_ops().
> 
> I haven't come up with another way of extended verbs that would be as easy for an application to use, given that most of the calls and data structures are reusable.
> 
> - Sean

Hi Sean,

I'm not sure about what this mechanism saves us over bumping the ABI numbers.
Actually, I think I do see a problem here, under the following situation:
	- All libraries (app, libibverbs, and libmlx4) support extensions.
	- A new verb (say extension "ib_new_verb" was added as an extension to the app,
          to libibverbs, and to libmlx4 and everything was compiled.
	- The APP is built on the full configuration, but is run on a configuration
	  which has the verb extension added to libmlx4, but NOT to libibverbs
	  (new libibverbs was installed originally, so that libmlx4 would succeed in the install,
	  then somehow libibverbs was rolled back to before "ib_new_verb" was added).

When the APP tries to run, it calls:
      ibv_get_device_ext_ops(struct ibv_device *device, "ib_new_verb");
This call will succeed (in the current implementation).
However, the verb helper function (ibv_cmd_<new_verb>) is not present
in libibverbs, so things will crash (if, indeed, libmlx4 can be loaded at all -

In fact, I'm not sure if it will fail loading because of unresolved references).
Indeed, I am not sure that the app can run at all due to unresolved references.

The problem here is that the new additions need support in libibverbs in order
to work (this is not simply a "pass-through" by libibverbs to the lower layer).

I may be wrong about all this --  userspace is not really my expertise.
If I am not wrong, what, then, is the advantage of this methodology over simply bumping the ABI numbers?

-Jack
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
