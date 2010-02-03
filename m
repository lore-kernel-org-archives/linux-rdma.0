From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 kernel parameters
Date: Wed, 3 Feb 2010 15:17:17 +0100
Message-ID: <6978b4af1002030617v4b55787ei4e66f72de662528a@mail.gmail.com>
References: <6978b4af1002030202h431384c4ub6de0313e51c4500@mail.gmail.com>
	 <20100203124200.GA30979@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100203124200.GA30979@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi there,

>>
>> The objective is to be able to memory-pin large portion of a machine
>> with lots of RAM, otherwise we are limited to about 16GB.
>> Does anyone has an hint or thoughts on what might be the problem?
>
> For this you can use the parameter log_mtts_per_seg which allows to
> define the granulairty of MTTs allocated. So for a given number of MTT
> segements (which is what the allocator really allocates), you control
> more registered memeory.

Great, thanks. I increased the log_mtts_per_seg to 5 and was able to
register more memory. But one question remaining: what is then the
maximum memory that one is able to register? 5 is the maximum value to
this parameter, so what does it mean?

cheers,
Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
