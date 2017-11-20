From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: =?UTF-8?Q?Re:_Problem_of_changing_the_inline_mode_or_turning_on_the?=
 =?UTF-8?Q?_encapsulation_support_of_Mellanox_NIC=e2=80=99s_eswitch?=
Date: Mon, 20 Nov 2017 11:13:20 +0200
Message-ID: <a7979b18-6b52-2d9a-0263-e56bcb119967@mellanox.com>
References: <HK2PR01MB0834534F555D6F532694DE5AF5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
 <20171120072351.GA18825@mtr-leonro.local>
 <HK2PR01MB083483A928DBF1EC8643BEA3F5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
 <83fb4706-2a4c-9e25-b5b6-92e433a7c746@mellanox.com>
 <20171120080241.GB18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120080241.GB18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Junxue ZHANG <jzhangcs-t+iU6Fs6CelnrVKH7T7RYw@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Byron Yi <yibairen1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Junxue,

On 20/11/2017 10:02, Leon Romanovsky wrote:
> On Mon, Nov 20, 2017 at 09:28:53AM +0200, Mark Bloch wrote:
>>>> NIC hardware model:
>>>> —————————
>>>> ConnectX®-4 EN network interface card, 40GbE dual-port QSFP28, PCIe3.0
>>>> x8, tall bracket, ROHS R6
>>>>
>>
>> We don't support encap/decap with ConnectX-4.
>> You should use ConnectX-4 LX or ConnectX-5.
>> Note that on ConnectX-5 you don't need to turn inline support as it isn't needed.
> 
> I spoke with Mark and it looks like documentation issue.
>

We will update our community doc to reflect we don't support vxlan encap/decap on
ConnectX-4.
I also would like to note, that you posted your question on the RDMA mailing list
while most/all discussions about devlink/switchdev/eswitch take place on the netdev mailing
list, if you have any more questions you should ask there, you will get a much faster replay
as most the netdev guys don't watch the RDMA mailing list :) 

> Thanks
> 

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
