From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Wed, 16 Dec 2015 11:02:19 -0700
Message-ID: <20151216180219.GD32594@obsidianresearch.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
 <567089F1.30004@redhat.com>
 <20151215220033.GB30404@obsidianresearch.com>
 <HE1PR05MB14188FDA12D077BA2720C84BB1EF0@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB14188FDA12D077BA2720C84BB1EF0-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 09:57:02AM +0000, Liran Liss wrote:
> Currently, namespaces are not supported for RoCE.

IMHO, we should not be accepting rocev2 without at least basic
namespace support too, since it is fairly trivial to do based on the
work that is already done for verbs. An obvious missing piece is the
'wc to gid index' API I keep asking for.

> That said, we have everything we need for RoCE namespace support when we get there.

Then there is no problem with the 'wc to gid index' stuff, so stop
complaining about it.

> All of this has nothing to do with "broken" and enshrining anything in the kapi.
> That's just bullshit.

No, it is a critique of the bad kAPI choices in this patch that mean
it broadly doesn't use namespaces, net devices or IP routing
correctly.

> The design of the RDMA stack is that Verbs are used by core IB
> services, such as addressing.  For these services, as the
> specification requires, all relevant fields must be reported in the
> CQE, period.  All spec-compliant HW devices follow this.

Wrong, the kapi needs to meet the needs of the kernel, and is
influenced but not set by the various standards.

That means we get to make better choices in the kapi than exposing
wc.network_type.

> If a ULP wants to create an address handle from a completion, there
> are service routines to accomplish that, based on the reported
> fields.  If it doesn't care, there is no reason to sacrifice
> performance.

I have no idea why you think there would be a performance sacrifice,
maybe you should review the patches and my remarks again.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
