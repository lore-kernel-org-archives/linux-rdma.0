From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ibv_reg_mr call failed
Date: Fri, 31 May 2013 09:23:48 +0300
Message-ID: <CAJZOPZJijePOJh2jPfBD9XjFY5eY=6txhmQq9BQ-e5aSZezMog@mail.gmail.com>
References: <B78BFEBC60BCD84AABFE4C6AE4239F303631433D@BY2PRD0412MB622.namprd04.prod.outlook.com>
	<51A20FC0.8070906@mellanox.com>
	<2AB4BFEB-D0E5-47E5-9E99-024BA7BB16AA@grassvalley.com>
	<CAJZOPZ+ESd4bq2dG4yYJG4qumaBWfd+4t_bTn4cHmFgCg8AYgw@mail.gmail.com>
	<B78BFEBC60BCD84AABFE4C6AE4239F303631FD9E@BY2PRD0412MB622.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B78BFEBC60BCD84AABFE4C6AE4239F303631FD9E-PabevnM9DETuy2SDsQ9Xi/nBZW37Ciw+nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liu Ginhann <Ginhann.Liu-Omk3PdybHIaN9aS15agKxg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 31, 2013 at 2:05 AM, Liu Ginhann
<Ginhann.Liu-Omk3PdybHIaN9aS15agKxg@public.gmane.org> wrote:
> Or,
>
> Tried __get_free_pages, kmalloc, all behave the same - fail in ibv_reg_mr call but the va mapped back is fine for peek and poke.
>
> Any other suggestion?

Yes, tell from where the EFAULT  error originates

>
> Hank
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
>> Sent: Monday, May 27, 2013 12:53 AM
>> To: Liu Ginhann
>> Cc: Or Gerlitz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: ibv_reg_mr call failed
>>
>> On Sun, May 26, 2013 at 4:52 PM, Liu Ginhann
>> <Ginhann.Liu-Omk3PdybHIaN9aS15agKxg@public.gmane.org> wrote:
>> > Will dig into it.Thanks.
>>
>>
>>
>> does this works if you use get_free_pages in the kernel instead of
>> kmem_cache?
>>
>> Or.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
