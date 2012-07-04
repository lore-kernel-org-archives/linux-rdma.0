From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 0/8] opensm: Improved mkey support
Date: Tue, 03 Jul 2012 17:25:08 -0700
Message-ID: <1341361508.5218.148.camel@auk75.llnl.gov>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340672058.5218.97.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

     I'm sending new versions of patches 1 and 3 to the list, which
correct merge/build issues introduced by other recently accepted
patches.  They will be marked as "V1.1".

     Jim

On Mon, 2012-06-25 at 17:54 -0700, Jim Foraker wrote:
> I'm about to post a set of patches intended to improve mkey support
> in OpenSM.  These patches have been fairly rigorously tested on a small
> fabric, and I believe are sufficiently stable for inclusion.  The
> primary intent here is threefold:
> 
> 1) Fix a multitude of edge case issues with the existing
> single-mkey-per-subnet support in OpenSM.  For instance, the current
> implementation provides no way to change an established non-zero mkey
> without rebooting or manually re-keying each CA on the entire subnet.
> 
> 2) Enable mkey protection across the fabric.  This involves not only
> setting a non-zero protection level, but also providing the SM with a
> sufficient information cache to initialize the subnet on restart without
> having to wait for mkey lease timeouts (provided one is set).
> 
> 3) Provide a basis on which to build multiple-mkey systems for OpenSM
> (be they per-host, KDF, or random) in the future.
> 
>      The patches add two new cache files: a port guid-to-mkey cache, and
> a neighboring link (port guid to port guid) cache.
>      The guid2mkey cache is used to provide a hint at the initial mkey
> for a CA during initialization.  It is a hint only; the SM is capable of
> dealing with cases where the guid2mkey cache is incorrect, although it
> may require waiting for (potentially multiple) mkey lease timeouts at
> non-zero mkey protection levels.  The guid2mkey cache is presented first
> in the patch set, as it ends up ameliorating several corner cases in a
> cleaner way than attacking them directly did.
>      The neighbors cache file provides an initial hint to the SM of what
> port guid we may expect at the opposite end of a link that is being
> initialized.  This is necessary at mkey protection level 2, where we
> cannot do the SubnGet necessary to determine the port guid to use in
> looking up an mkey hint.
>      The changes to the osm_req functions to support mkeys in patch 2
> now require plock to be held when called.  This was generally already
> the case, but there were a few spots where it was not.  In most of these
> cases, the plock is still not technically necessary, as they occur
> during hops 0/1 when DR path traversal is trivial.  I wrapped all of
> these occurrences in locks in a separate patch (#3), in order to make
> the changes more obvious and invite comment.
> 
>      Jim

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
