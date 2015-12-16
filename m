From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Wed, 16 Dec 2015 14:25:11 -0700
Message-ID: <20151216212511.GA14301@obsidianresearch.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
 <567089F1.30004@redhat.com>
 <CAG9sBKNa4Hd0WVqhZCLeqXjc2zE2h+dBwF6zVgGT0R_Gt1FEwA@mail.gmail.com>
 <5671CBF4.4060602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5671CBF4.4060602-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 03:39:16PM -0500, Doug Ledford wrote:

> These patches add the concept of duplicate GIDs that are differentiated
> by their RoCE version (also called network type).

and by vlan, and smac, and ... Basically everything network unique about
a namespace has to be encapsulted in the gid index now. Each namespace
thus has a subset of gid indexes that are valid for it to use for
outbound and to recieve packets on.

roce didn't really have a way to work with net namespaces, AFAIK (?)
so it gets a pass.

But rocev2 very clearly does. It needs needs to address the issue
outlined in commit b8cab5dab15ff5c2acc3faefdde28919b0341c11 (IB/cma:
Accept connection without a valid netdev on RoCE)

That means cma.c needs to get the gid index every single CMA packet it
processes and confirm that the associated net device is permitted to
talk to the matching CM ID. 

It is no mistake there is a hole in cma.c waiting for this code, when
Haggai did that work it was very clear in my mind that rocev2 would
need to slot into here as well.

> Jason's objections are this:
> 
> 1)  The lazy resolution is wrong.

Wrong in the sense it doesn't actually exist in a usable form
anyplace.

cma.c does not do it, and absoultely must as discussed above.

init_ah_from_wc needs to do it, and maybe does. It is hard to tell,
perhaps a 'rdma_wc_to_dgid_index()' is actually open coded in there
now. Just from a code readability perspective that is ugly.

Then we get into the missing route handling in all places that
construct a rocev2 AH...

> Jason's preference would be that the above issues be resolved by
> skipping the lazy resolution and instead doing proactive resolution
> on

I am happy with lazy resolution, that is a fine compromise.

I just want to see kapi that makes sense here. It is very clear to me
no kernel user can possibly correctly touch a rocev2 UD packet without
retrieving the gid index, so we must have a kAPI for this.

> namespace.  Or, at a minimum, at least make the information added to the
> core API not something vendor specific like network_type, which is a
> detail of the Mellanox implementation.

I keep suggesting a rdma_wc_to_dgid_index() API call.

Perhasp most of he code for this already seems to exist in
init_ah_from_wc.

> 1 - Actually, for any received packet with associated IP address
> information.  We've only enabled net namespaces for IP connections
> between user space applications, for direct IB connections or for kernel
> connections there is not yet any namespace support.

IHMO, this is actually a problem for rocev2.

IB needs more work to create a rdma namespace, but rocve2 does not.

The kernel software side should certainly be completed as a quick
follow on to this series, that means the use of gid_indexes at all
uAPI access points needs to be checked for rocev2.

HW support is needed to complete rocve2 containment, as the hw must
check the gid_index on all directly posted WCs and *ALL* rx'd packets
for a QP to ensure it is allowed.

Some kind of warn on until that support is available would also be
great.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
