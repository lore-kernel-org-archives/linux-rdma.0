From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx5 + SRP: max_qp_sz mismatch
Date: Wed, 27 Aug 2014 13:19:46 +0200
Message-ID: <53FDBED2.2060707@acm.org>
References: <CADvaNzWGThMx1gMYfheFVwHzk10+8KWmAPkYZ1_FxArhdmri8Q@mail.gmail.com>	<53F36420.3060607@dev.mellanox.co.il>	<CADvaNzVkKuvHw58meQD962VSm4Y-QZoHC3ndsYSBW8rw7S68cw@mail.gmail.com> <CADvaNzWAZiNiwBAVYVA5it7K3A4CAozkeHn8SowYNT7iE6YykA@mail.gmail.com> <53FCB18F.5030608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53FCB18F.5030608-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/26/14 18:10, Sagi Grimberg wrote:
> On 8/20/2014 6:51 PM, Mark Lehrer wrote:
>>>  From what I see srp_sq_size is controlled via
>>> configfs. Can you set it to 2048 just for the sake of
>>> confirmation this is indeed the issue?
>>
>> Now that we have confirmed that this works, what is the proper way to
>> fix the problem?  Is the core issue with mlx5 or srp?
> 
> Since I don't know how true send queue size can be computed from the
> device capabilities at the moment -I can suggest a fix to srpt to retry
> with srp_sq_size/2 (ans so on until it succeeds...)
> 
> CC'ing Bart and Eli.

Sounds fine to me. I wish a more elegant approach would be possible but
I have not yet found an approach that is more elegant.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
