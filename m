From: Liu Ginhann <Ginhann.Liu-Omk3PdybHIaN9aS15agKxg@public.gmane.org>
Subject: Re: ibv_reg_mr call failed
Date: Sun, 26 May 2013 13:52:47 +0000
Message-ID: <2AB4BFEB-D0E5-47E5-9E99-024BA7BB16AA@grassvalley.com>
References: <B78BFEBC60BCD84AABFE4C6AE4239F303631433D@BY2PRD0412MB622.namprd04.prod.outlook.com>,<51A20FC0.8070906@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51A20FC0.8070906-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Will dig into it.Thanks.



On May 26, 2013, at 6:36 AM, "Or Gerlitz" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> On 24/05/2013 20:43, Liu Ginhann wrote:
>> Ibv_reg_mr() call return EFAULT - bad address
> 
> Basically, AFAIK, the IB stack should support what you are trying to do, If you tell from which code e.g in libibverbs/libmlx4 or the kernel this value is returned, it might be helpful for further assisting you.
> 
> Or.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
