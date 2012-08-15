From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Trust model for raw QPs
Date: Wed, 15 Aug 2012 17:28:29 +0300
Message-ID: <502BB20D.8040403@mellanox.com>
References: <502BA406.2060409@mellanox.com> <000001392a9b6b2a-ba67aaa6-b7b8-4c80-90db-03f0172aef6e-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000001392a9b6b2a-ba67aaa6-b7b8-4c80-90db-03f0172aef6e-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15/08/2012 17:06, Christoph Lameter wrote:
> On Wed, 15 Aug 2012, Or Gerlitz wrote:
>
>> Currently, for an app to open a raw QP from user space, we (verbs) require
>> admin permission, for which we (Mellanox) got customer feedback saying this is
>> problematic on some of the environments.
>
> Well yes it is but the kernel mod is a one line to get rid of this problem.

Its one LOC that has behind it many lines  of reasoning... e.g as 
specified in the change-log, those QP are to some extent the RDMA stack 
form of packet/raw sockets.

>
>
>> Suppose we allow to user to provide source mac+vlan when creating the QP or when modifying its state, and the HW can enforce that -- in that case I think its OK to remove that restriction e.g ala what is allowed today with user space UD QPs when the fabric is IB.
>
> Well yes that would mean that the source mac and vlan are configured with
> admin permissions and then the app would run without within the
> constraints established in priviledged moded.

There a co-existence between the IP stack and the RDMA stack, which is 
for example exercised by the RDMA-CM design, here also, the admin 
configured a MAC and VLAN for a netdevice that is bounded to a HW 
NIC/port we want to create RAW QP on, and there's a non privileged user 
space app that want to  generate frames with this mac/vlan, and we say 
its allowed once the HW can enforce that.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
