From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Wed, 16 Dec 2015 09:57:02 +0000
Message-ID: <HE1PR05MB14188FDA12D077BA2720C84BB1EF0@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
 <567089F1.30004@redhat.com> <20151215220033.GB30404@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151215220033.GB30404-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-

> > Since you and Jason did not reach a consensus, I have to dig in and
> > see if these patches make it possible to break namespace confinement,
> > either accidentally or with intentionally tricky behavior.  That's
> > going to take me some time.
> 
> Everything to do with parsing a wc and constructing an AH is wrong in this
> series, and the fixes require the API changes I mentioned ( add 'wc to gid
> index' API call, add 'route to AH' API call)
> 
> Every time you read 'route validation' - that is an error, the route should
> never just be validated, it is needed information to construct a rocev2 AH. All
> the places that roughly hand parse the rocev2 WC should not be open coded.
> 
> Even if current HW is broken for namespaces we should not enshrine that in
> the kapi.
>

Currently, namespaces are not supported for RoCE.
So for this patches, this is irrelevant.
That said, we have everything we need for RoCE namespace support when we get there.

All of this has nothing to do with "broken" and enshrining anything in the kapi.
That's just bullshit.

The crux of the discussion is the meaning of the API.
The design of the RDMA stack is that Verbs are used by core IB services, such as addressing.
For these services, as the specification requires, all relevant fields must be reported in the CQE, period.
All spec-compliant HW devices follow this.

If a ULP wants to create an address handle from a completion, there are service routines to accomplish that, based on the reported fields.
If it doesn't care, there is no reason to sacrifice performance.

--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
