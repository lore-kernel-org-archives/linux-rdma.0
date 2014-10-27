From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/9] Peer-Direct support
Date: Mon, 27 Oct 2014 14:25:30 +0200
Message-ID: <544E39BA.60809@dev.mellanox.co.il>
References: <1414065777-21173-1-git-send-email-yishaih@mellanox.com> <CAG4TOxNDNNKYF0VLf45XvaNPqOr=V=iq5qFCeUG87eDDa7Kbeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxNDNNKYF0VLf45XvaNPqOr=V=iq5qFCeUG87eDDa7Kbeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/23/2014 8:29 PM, Roland Dreier wrote:
> On Thu, Oct 23, 2014 at 5:02 AM, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> The API defined for Peer-Direct is described in this cover letter.
>> The required implementation for a hardware device to expose memory
>> buffers over Peer-Direct is also detailed in this letter.
>
> I don't see how I can justify merging this (for now at least), given
> that there are no actual users of all this (fairly complex) new code,
> besides a sample that doesn't actually do anything useful.  Is there
> any actual consumer that might go upstream someday that we can at
> least review now?
>

Intel people pointed that CCL Direct for Intel Xeon Phi uses this API. 
See http://www.spinics.net/lists/linux-rdma/msg21605.html . We are 
checking with Intel whether the relevant stuff can be shared for some 
early review.

Additional use case for this Infrastructure can be the ability to do 
remote RDMA by exposing the UAR pages of the Mellanox HCAs and other 
NICs as peer direct memory.  For this functionality to work, the only 
missing component in the kernel side is allowing registration of UAR 
pages. Relatively simple extension of mlx4_ib/mlx5_ib to be a peer 
direct client can add this missing component, in a nice, well integrated 
way. This will allow application to perform remote posting of work 
requests. This can be useful, for example in a gateway application. The 
application exposes QPs to remote machine inside the cluster. The remote 
machines can post work requests directly into the gateway machine using 
RDMA. This way, the gateway machine does not need any software 
involvement in the data path, improving the gateway machine scalability.


>> This makes the usage of peer-direct almost completely transparent to
>> the individual hardware drivers. The only changes required in the low
>> level IB hardware drivers is supporting an interface for immediate
>> invalidation of registered memory regions.
>
> Why do we need immediate invalidation of memory regions?
>

We have listed the need for immediate invalidation in previous e-mails, 
specifically at:
https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg21375.html

To summarize, some of the hardware devices must block all accesses to 
the memory registered immediately in some use cases. This is needed to 
maintain correctness and forward progress, for example if the hardware 
must switch tasks to progress. To support these hardware devices, we 
implemented a callback to support invalidation. This allows the peer 
memory client to be sure that the memory will not be accessed by the 
hardware, and simplify their software design.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
