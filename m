From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_cache.c: Eliminate unneeded define
Date: Mon, 2 Nov 2009 12:19:42 -0400
Message-ID: <f0e08f230911020819m4d45bfabqb82a71178e08226e@mail.gmail.com>
References: <20091021125026.GA18250@comcast.net> <20091022150150.GL20210@me>
	 <f0e08f230911020731v26824599xab02b93094397ec3@mail.gmail.com>
	 <20091102160126.GD21323@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091102160126.GD21323@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 2, 2009 at 12:01 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 11:31 Mon 02 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> A nit but any reason for that one message being inconsistent (in ter=
ms
>> of case) with the other log messages there ?
>
> Other messages are debug printouts and cannot be compared.

That seems pretty arbitrary to me. I don't think that's the case with
different levels of printing elsewhere.

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
