From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/7] libibverbs: Add link layer field port attribute
Date: Wed, 20 Jul 2011 12:33:27 -0600
Message-ID: <20110720183327.GJ18090@obsidianresearch.com>
References: <20110719170454.GD18090@obsidianresearch.com>
 <CAJZOPZ+=3jr18x8Uxt73jAfT0bdPhntOez9dyZfmiHOF5REOSw@mail.gmail.com>
 <20110719195020.GE18090@obsidianresearch.com>
 <CAJZOPZ+2S=agGurUC6393e7mqQy4Ob1jaseeoWxeZe2Yu-kCLg@mail.gmail.com>
 <20110719203140.GG18090@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373136EFE8F@ORSMSX102.amr.corp.intel.com>
 <20110719213902.GH18090@obsidianresearch.com>
 <CAJZOPZ+HjKiSr=Q6ti9zPfx0YnGXK796xK+Y8fDtLLuM3SnKbA@mail.gmail.com>
 <20110720181052.GI18090@obsidianresearch.com>
 <CAJZOPZL9T2XK25BxtOBJj4vW3uSZz4yDWR4wfBxvUaeOgrWU3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZL9T2XK25BxtOBJj4vW3uSZz4yDWR4wfBxvUaeOgrWU3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2011 at 09:20:41PM +0300, Or Gerlitz wrote:
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> > Looks like! Sorry for the confusion
> 
> Jason, thanks for your detailed review && feedback, just to recap,
> the patches are okay except the missing entry for the new GID change
> event in ibv_event_type_str which I will add, correct?

Yes, that was the only important thing I saw.

I assume Roland was happy with the #define trick for compatibility
last time it came up?

Looking at the diff, maybe re-shuffle the order of the #define trick
so it is easier to follow, and call ibv_query_port rather than short
cut through the context for better future compatibility.

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..40e8802 100644
@@ -766,6 +774,18 @@ int ibv_query_device(struct ibv_context *context,
  */
 int ibv_query_port(struct ibv_context *context, uint8_t port_num,
 		   struct ibv_port_attr *port_attr);
+static inline int ___ibv_query_port(struct ibv_context *context,
+				    uint8_t port_num,
+				    struct ibv_port_attr *port_attr)
+{
+	/* For compatability linking with old libibverbs */
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
+	port_attr->pad = 0;
+
+	return ibv_query_port(context,port_num,port_attr);
+}
+#define ibv_query_port(context, port_num, port_attr) \
+	___ibv_query_port(context, port_num, port_attr)
 
 /**
  * ibv_query_gid - Get a GID table entry
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
