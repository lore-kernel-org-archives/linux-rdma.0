From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/core: Align casting method of
 ib_device_cap_flags enumerations to ULL
Date: Mon, 6 Jun 2016 10:45:42 -0700
Message-ID: <340a789f-5983-acd0-ded0-636a2cf3fad2@sandisk.com>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
 <1465230880-25953-3-git-send-email-maxg@mellanox.com>
 <20160606170413.GB28622@infradead.org>
 <CALq1K=JWPk6nPjTV0z1HwfmtnO77Nkyaqx-JTB=8JwH0UtorDA@mail.gmail.com>
 <20160606172246.GB21118@infradead.org> <20160606174011.GB24836@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160606174011.GB24836-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, hch <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/06/2016 10:40 AM, Greg KH wrote:
> On Mon, Jun 06, 2016 at 10:22:46AM -0700, hch wrote:
>>> Later on, we will wrap all these shifts in BIT() macros as Greg suggested.
>>
>> Big NAK to any use of that macro.
>
> That's odd, given that most of the kernel has already converted to use
> it.  You can try to keep it out of this subsystem, but you will get
> patches to convert it from random people and it will wear you down over
> time...

Hello Greg,

It is considered a bad programming practice to introduce macros that 
obfuscate C operations. All the BIT() macro does is a shift operation. 
Writing the shift explicitly instead of using the BIT() macro makes 
source code easier to read. So why has the BIT() macro ever been introduced?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
