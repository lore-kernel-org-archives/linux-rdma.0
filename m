From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Write Packets to InfiniBand HCA
Date: Thu, 5 Jan 2012 12:10:40 +0200
Message-ID: <4F057720.6030501@mellanox.com>
References: <CANtVascW3aRunBOSevwJgv8vN6gnNjmZM=8vLii=pUsDaFam3w@mail.gmail.com> <4C2744E8AD2982428C5BFE523DF8CDCB5CCCCCFB63@MNEXMB1.qlogic.org> <CANtVasebZqgxoZOVMJ7uRGN7subRZqgq1vWjh_r11vXxa--Qog@mail.gmail.com> <CAL1RGDUOZw-+8R+rbsErd7PdB4gUH=zv1NYN-W1bxO5_ZgpdXQ@mail.gmail.com> <CAJZOPZ+-muTk9s_k61-+_=JFJRsg0RGOvGuMJu46mYCAYR7uqw@mail.gmail.com> <CANtVaseDHYrS+oOZ8qYaxmFLfEVtfjt6hBGK0m0Y4KZ-CvLgWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANtVaseDHYrS+oOZ8qYaxmFLfEVtfjt6hBGK0m0Y4KZ-CvLgWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/4/2012 11:23 PM, Greg I Kerr wrote:
> Yes I want to do this with IB. I wasn't aware that I could use a UD QP 
> to write my own packets to the wire. Is this what you're suggesting I 
> can use a UD QP for?

You'll have to further clarify the "my own packets" part of your 
sentence... IB have some layers which come into play in various elements 
(software/hardware of HCAs/switches) during the life cycle of the 
packet. Specifically each IB packet would have an IB L2 header called 
LRH, IB also has L3 header named GRH which is optional unless you need 
multicast (or IBoE). The UD thing I mentioned is IB's L4 - the 
transport. The most common transports are UD and RC. So if you go UD the 
packet will have L2 (LRH) and L4 UD headers (called BTH plus DTH) which 
on top of you add the payload.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
