From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: Re: watchdog timer
Date: Mon, 21 May 2012 17:51:29 -0700
Message-ID: <4FBAE311.3080909@nasa.gov>
References: <4FB5E69A.7010602@nasa.gov> <4FB649A6.2060602@dev.mellanox.co.il>	<4FB65E30.4070805@nasa.gov> <20120518081029.01004d2c.weiny2@llnl.gov> <4FB66A6C.1060703@dev.mellanox.co.il> <20120521100831.a434152f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120521100831.a434152f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I believe the issue (not certain - need more test time) was caused by not specifying all vlarb entries,
even those unused. So, QoS on, but incomplete specification. OFED HowTo examples do this, so I figured it
was OK.

Its also possible that some software may have been specifying an un-configured SL - without my permission ;)
Maybe vl 0 was loosing its turn in arbitration and got starved for > +3%/-51% 400,000 symbols when the HCA
was passing back flow control update?

Unfortunately - it usually worked, except under load.

Think its working now.

bob

btw Ira, you get to trade every ! into a beer the next time I see you.
!!! - there, an even 6 pack


On 05/21/2012 10:08 AM, Ira Weiny wrote:
> On Fri, 18 May 2012 11:27:40 -0400
> Hal Rosenstock<hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  wrote:
>
>> Ira,
>>
>> On 5/18/2012 11:10 AM, Ira Weiny wrote:
>>> In our situation the FW in the switch had a bug.
>>
>> Do you recall what the bug was, which firmware version had the bug and
>> which one fixed it ?
>
> I don't recall but it was not Mellanox hardware.
>
> Ira
>
>>
>> -- Hal
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
