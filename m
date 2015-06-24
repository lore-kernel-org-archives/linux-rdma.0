From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] IB/srpt: Convert use of __constant_cpu_to_beXX to
 cpu_to_beXX
Date: Wed, 24 Jun 2015 10:18:44 -0700
Message-ID: <558AE674.3080805@sandisk.com>
References: <20150624044213.GA4998@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150624044213.GA4998@vaishali-Ideapad-Z570>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/23/2015 09:42 PM, Vaishali Thakkar wrote:
> In little endian cases, the macro cpu_to_be{16,32,64} unfolds to
> __swab{16,32,64} which provides special case for constants. In
> big endian cases, __constant_cpu_to_be{16,32,64} and
> cpu_to_be{16,32,64} expand directly to the same expression. So,
> replace __constant_cpu_to_be{16,32,64} with cpu_to_be{16,32,64}
> with the goal of getting rid of the definitions of
> __constant_cpu_to_be{16,32,64} completely.

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
