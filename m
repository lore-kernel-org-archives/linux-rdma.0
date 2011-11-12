From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sat, 12 Nov 2011 13:31:15 -0800
Message-ID: <1321133475.22109.85.camel@haakon2.linux-iscsi.org>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-oX94=81Gdr2cs0VFoF8Yb+B1DAT2Z+h2UeP6q111Rv7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oX94=81Gdr2cs0VFoF8Yb+B1DAT2Z+h2UeP6q111Rv7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2011-11-11 at 12:41 +0100, Bart Van Assche wrote:
> > +static void srpt_drop_tport(struct se_wwn *wwn)
> > +{
> > +       struct srpt_port *sport = container_of(wwn, struct srpt_port, port_wwn);
> > +
> > +       pr_debug("drop_tport(%s\n", config_item_name(&sport->port_wwn.wwn_group.cg_item));
> 
> A minor comment: the above statement always never prints the port name
> - it always prints the following:
> 
> ib_srpt drop_tport((null)
> 

This comes from modern target_fabric_drop_wwn() -> config_item_put() ->
config_group_put() releasing the top level fabric config_group @
port->port_wwn.wwn_group before the last config_item_put() -> struct
configfs_group_operations->drop_item() -> TFO->drop_wwn() ->
srpt_drop_tport() has been invoked.

The informational config_item_name() also appears in a handful of other
fabric TFO->drop_wwn() code, which is really left-over usage from pre v4
target_core_fabric_configfs.c days when struct config_group was setup
and released directly by the fabrics.

Anyways, I'll go ahead and drop this legacy usage of config_item_name()
tree-wide.  Thanks for pointing this out.

--nab






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
