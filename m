From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] RDMA CM + XRC, take two
Date: Fri, 13 May 2011 14:39:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373F304@ORSMSX101.amr.corp.intel.com>
References: <4DC86BB2.1020002@systemfabricworks.com>
 <1828884A29C6694DAF28B7E6B8A82373F23B@ORSMSX101.amr.corp.intel.com>
 <984CAD75-D012-4725-B294-99B1AF32E49B@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <984CAD75-D012-4725-B294-99B1AF32E49B-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The typical use case foe xrc is for lots of related processes on each node. In
> this case it would be helpful to cache these to avoid P^2 effects. The CM
> seems like a nice place to do this. The usual problem is knowing when to
> stop.

After your thumb recovers, I could use more details here.  I didn't follow what you were trying to say.

> I'm not thrilled with 3. Seems to me like these concepts don't merge well.
> The idea behind the implementation is to let apps use the file system
> permissions to control who can join. Whatever we do has to preserve this.

I agree with using the file system permissions.  This was the reason behind adding some new call like ibv_share_pd().

In hindsight, the APIs could have been simpler if we had just hid the PD entirely.  I'd hate to make it worse by having two 'protection domain' objects.  We end up adding new function parameters and structure fields.  How many apps allocate more than 1 PD or XRC domain per device?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
