From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH/libmlx] Set the ibv_wc.opcode even if the wc is an error wc
Date: Wed, 9 Mar 2011 12:31:06 +0100
Message-ID: <AANLkTimmFu7OMwM+NQNNwbYki-rFsjEQzTOWzZJO2B7v@mail.gmail.com>
References: <20110309042613.GA21606@obsidianresearch.com> <4D771E0F.7040402@mellanox.com>
 <20110309070441.GA25213@obsidianresearch.com> <4D772E36.90103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D772E36.90103-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 9, 2011 at 8:37 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> The question is
> how to educate people that write to IB, should we tell them now they can
> look on the opcode? so far I was telling people never do so if the status
> isn't success.

And with good reason: I know at least one HCA / driver combination for
which the opcode in error completions can differ from the opcode in
the corresponding work request. As mentioned before this behavior is
compliant with the IBTA specs.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
