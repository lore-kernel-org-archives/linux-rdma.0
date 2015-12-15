From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Tue, 15 Dec 2015 15:00:33 -0700
Message-ID: <20151215220033.GB30404@obsidianresearch.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
 <567089F1.30004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <567089F1.30004-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 15, 2015 at 04:45:21PM -0500, Doug Ledford wrote:

> In particular, Liran piped up with this comment:
> 
> "Also, I don't want to do any route resolution on the Rx path. A UD QP
> completion just reports the details of the packet it received.
> 
> Conceptually, an incoming packet may not even match an SGID index at
> all.  Maybe, responses should be sent from another device. This should
> not be decided that the point that a packet was received."
> 
> The part that bothers me about this is that this statement makes sense
> when just thinking about the spec, as you say.  However, once you
> consider namespaces, security implications make this statement spec
> compliant, but still unacceptable.

This is where I got to and decided there is no desire to make a
correct patch for this stuff.

You are completely correct in your comments above.

> Since you and Jason did not reach a consensus, I have to dig in and see
> if these patches make it possible to break namespace confinement, either
> accidentally or with intentionally tricky behavior.  That's going to
> take me some time.

Everything to do with parsing a wc and constructing an AH is wrong in
this series, and the fixes require the API changes I mentioned ( add
'wc to gid index' API call, add 'route to AH' API call)

Every time you read 'route validation' - that is an error, the route
should never just be validated, it is needed information to construct
a rocev2 AH. All the places that roughly hand parse the rocev2 WC
should not be open coded.

Even if current HW is broken for namespaces we should not enshrine that
in the kapi.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
