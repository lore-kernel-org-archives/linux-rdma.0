From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: does i need compat-rdma package
Date: Wed, 24 Dec 2014 13:38:30 +0200
Message-ID: <549AA5B6.3020106@mellanox.com>
References: <CACaajQs03WqcSdrxF3r78wGKL494V5YS5Woa8tW4t1e3qAGGaQ@mail.gmail.com>
 <549A772D.1040608@mellanox.com>
 <CACaajQvDQ9N9v_q1AAk+bxpMbQ947FEJ7dqTaG9Nj9i--4-9Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQvDQ9N9v_q1AAk+bxpMbQ947FEJ7dqTaG9Nj9i--4-9Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/24/2014 12:20 PM, Vasiliy Tolstov wrote:
> Thanks, last question - i'm try to use rsocket and AF_IB in my app,
> what minimal kernel version does support this?
AF_IB was merged in 3.11, BTW - can you share what's your motivation to 
use it? as for rsockets, basically any kernel thatsupports the rdma_cm 
along with it's user-space device, this goes a while back... you 
mentioned 3.14, should be OK
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
