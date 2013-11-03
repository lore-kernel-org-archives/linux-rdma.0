From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 08/10] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Sun, 3 Nov 2013 14:20:02 +0200
Message-ID: <52763F72.1080107@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com>	<1383222255-22699-9-git-send-email-sagig@mellanox.com>	<527410F3.6040704@acm.org> <CAJZOPZLnyqzzx91ohmW+exy0k8g-FX6reSBCGmh_F2tTGWWOog@mail.gmail.com> <527575D0.9050802@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527575D0.9050802-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/2/2013 11:59 PM, Bart Van Assche wrote:
> On 2/11/2013 12:21, Or Gerlitz wrote:
>> On Fri, Nov 1, 2013 at 10:37 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> 
>> wrote:
>>> On 31/10/2013 5:24, Sagi Grimberg wrote:
>>>>
>>>> This patch implements IB_WR_REG_SIG_MR posted by the user.
>>>>
>>>> Baisically this WR involvs 3 WQEs in order to prepare and properly
>>>> register the signature layout:
>>>>
>>>> 1. post UMR WR to register the sig_mr in one of two possible ways:
>>>>       * In case the user registered a single MR for data so the UMR 
>>>> data
>>>> segment
>>>>         consists of:
>>>>         - single klm (data MR) passed by the user
>>>>         - BSF with signature attributes requested by the user.
>>>>       * In case the user registered 2 MRs, one for data and one for
>>>> protection,
>>>>         the UMR consists of:
>>>>         - strided block format which includes data and protection 
>>>> MRs and
>>>>           their repetitive block format.
>>>>         - BSF with signature attributes requested by the user.
>>>>
>>>> 2. post SET_PSV in order to set the for the memory domain initial
>>>>      signature parameters passed by the user.
>>>>
>>>> 3. post SET_PSV in order to set the for the wire domain initial
>>>>      signature parameters passed by the user.
>>>>
>>>> This patch also introduces some helper functions to set the BSF 
>>>> correctly
>>>> and determining the signature format selectors.
>>>
>>>
>>> Has it already been explained somewhere what the abbreviations KLM, 
>>> BSF and
>>> PSV stand for ?
>>
>> Bart, these are all HW T10 related objects/concepts, we made an effort
>> to keep them contained within the mlx5 driver such that they don't
>> show up on the IB core layer. If this helps for the review, Sagi can
>> spare few words on each, sure.
>
> Hello Or,
>
> I would certainly appreciate it if these abbreviations could be 
> clarified further. That would allow me to understand what has been 
> explained in the above patch description :-)
>
> Bart.
>
>

Hey Bart,

As Or said, these concepts are vendor specific and not exposed to IB 
core layer And their naming is also pure Mellanox.
This is also might change in future generation HCAs.

In general the sig_mr (signature enabled) is a memory region that can 
register other memory regions (hint: data MR and protection MR) and is 
attached to (mlx5) signature objects.

KLM: A tuple {key, addr, len} that is used for indirect registration.
BSF: this is the object that describes the wire and memory layouts. we 
call it a byte-stream format.
PSV: this is the signature variable that is computing the guards - used 
for generation and/or validation. exists for each domain.

So We constructed REG_SIG_MR operation as a 3-way operation:
- Online registration for sig_mr:  Register in an indirect manner for 
data and protection (if exists).
   If no protection exists in memory domain the sig_mr registers the 
data buffer (KLM).
   If protection exists in memory domain (DIX) the sig_mr registers data 
and protections buffers (KLMs)
   In the DIX case, order to transfer DIF every pi_interval the 
registration also defines the strided format of the execution 
(pi_interval of data followed by 8byte of protection in a repetitive 
manner).

- Define signature format of wire/memory domains (BSF object)
   tell the HW how to treat the signature layout in each domain 
(signature type, pi_interval etc...)

- Set the signature variables for each domain (memory, wire)
   Here we place the seeds that the HW starts signature computation (In 
the DIF case, Initial CRC, Initial ref_tag, initial app_tag).

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
