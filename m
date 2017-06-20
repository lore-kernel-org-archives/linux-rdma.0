From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Tue, 20 Jun 2017 09:38:55 -0600
Message-ID: <20170620153855.GA29283@obsidianresearch.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-4-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB143340@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BArF5U49WQ2PcYjpSbPpQmyubJQ6vKKUer_L05QBQpT0w@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1436F6@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BA+Bpwbx+pZivK_+jRLc9kCrvhQkPy4tKcaTqUZhfRiOg@mail.gmail.com>
 <20170615165751.GB23773@obsidianresearch.com>
 <CAAKD3BC-PdUWArbQ3FOT_E-uNGC2w4JWaY2bTksVy3qzn1ii=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BC-PdUWArbQ3FOT_E-uNGC2w4JWaY2bTksVy3qzn1ii=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 20, 2017 at 03:03:36PM +0300, Matan Barak wrote:

> What about the specification deceleration?
> Since this patch-set builds everything statically, we need somehow to
> hash the entities correctly
> according to their higher ids.

Don't try and build everything statically.

Do what I suggested in Santa Fe - have a .rodata description that is
easy for the programmer to build and understand, 'compile' that into a
fast-access version (eg a hash table, etc) that is suitable for runtime
use.

> When a developer wants to add additional attributes he can't just
> add them wherever he wants.  He needs to understand the
> implications. Attributes which are added as common attribute ids are

We can look at this stuff based on the attribute ID value and where in
the code it lives, not based on the type of a .rodata structure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
