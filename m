From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Trust model for raw QPs
Date: Wed, 15 Aug 2012 17:36:55 +0000
Message-ID: <000001392b5c08ee-a7b281fa-8fd1-4828-8595-b477b155eca7-000000@email.amazonses.com>
References: <502BA406.2060409@mellanox.com> <20120815164701.GD30810@obsidianresearch.com> <CAJZOPZLiEguZv_HDe51Sg2bqpqVfGh76jNcLn-OfnreMGdmHvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLiEguZv_HDe51Sg2bqpqVfGh76jNcLn-OfnreMGdmHvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 15 Aug 2012, Or Gerlitz wrote:

> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> > Can you fix this by elevating the process with SELinux?
>
> Chirstoph, do you think this would valid option from users standpoint?

Sure. If SELinux can be used to compromise systems security (in a
controlled fashion) then I think we finally found a reason to use the
stuff. Could someone explain how this would work? Hopefully this is easily
usable and controllable?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
