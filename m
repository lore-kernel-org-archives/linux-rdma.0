From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs] init.c: increase sysfs read buffer size to 16
Date: Wed, 9 Dec 2015 15:05:09 +0000
Message-ID: <8CCFAB20-21D8-4915-98C6-3DE6130BF389@cisco.com>
References: <1449184181-25676-1-git-send-email-jsquyres@cisco.com>
 <56658940.5040506@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56658940.5040506-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <56A788B2DFA4794880611C317752A3A2-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Xuyang Wang (xuywang)" <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Any further comments on this?

Doug -- does it look ok to you?


> On Dec 7, 2015, at 5:27 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> 
> On 12/04/2015 01:09 AM, Jeff Squyres wrote:
>> The default value of 8 is too small to read
>> /sys/class/infiniband/usnic_x/node_type, which contains "6: usNIC
>> UDP".  Per a7a73a8c1b39362f1701256bc772d82847832f9c, the too-small
>> buffer causes a stderr warning to be emitted from ibv_devinfo when
>> reading usNIC devices.
>> 
>> This commit therefore increases the buffer size to 16, which is long
>> enough to read the usNIC node_type value.
> 
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
