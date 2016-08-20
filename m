From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Sat, 20 Aug 2016 01:15:43 +0000
Message-ID: <SN1PR0201MB1870C69552DFB8DE185EB0C881170@SN1PR0201MB1870.namprd02.prod.outlook.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
 <4cf7c492-ed42-d9cc-38e8-15d8c50d585f@grimberg.me>
 <20160819183334.GB20340@obsidianresearch.com>
 <HE1PR05MB1642B58A0D293DB54C005EDEAA160@HE1PR05MB1642.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/19/16 12:00, Bodong Wang wrote:=0A=
> On 8/19/2016 1:33 PM, Jason Gunthorpe wrote:=0A=
>> On Wed, Aug 17, 2016 at 05:35:42PM +0300, Sagi Grimberg wrote:=0A=
>>>> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h=
=0A=
>>>> index ccf1d51..87e4332 100644=0A=
>>>> +++ b/include/infiniband/verbs.h=0A=
>>>> @@ -209,6 +209,13 @@ enum ibv_odp_general_caps {=0A=
>>>> 	IBV_ODP_SUPPORT =3D 1 << 0,=0A=
>>>> };=0A=
>>>>=0A=
>>>> +#define ibv_is_qpt_supported(caps, qpt) ((caps) & (1 << (qpt)))=0A=
>>> This looks useful, but not directly related to this patch. Would=0A=
>>> be better to add it in a stand-alone patch (even if its a one-liner).=
=0A=
>> And of course it should be a static inline....=0A=
>=0A=
> This is a macro, not a function.=0A=
=0A=
Hello Bodong,=0A=
=0A=
In case you didn't know this: when introducing new functionality, =0A=
whenever there is a choice between introducing this functionality as a =0A=
macro or an inline function, using an inline function is preferred. With =
=0A=
an inline the compiler namely can perform type checking, arguments do =0A=
not have to be surrounded by parentheses and using an argument multiple =0A=
times in the body of the inline function is safe even if the argument =0A=
expression has side effects.=0A=
=0A=
Bart.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
