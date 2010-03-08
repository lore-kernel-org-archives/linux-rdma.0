From: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: add support of reload net topology file
Date: Mon, 8 Mar 2010 23:51:36 +0200
Message-ID: <694d48601003081351o2f661356seb17364cf5d734f9@mail.gmail.com>
References: <4B7C0256.7080505@voltaire.com> <20100227152212.GG13592@me>
	 <4B8BDF87.3020107@gmail.com> <20100302163511.GL13592@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100302163511.GL13592@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 2, 2010 at 6:35 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 17:38 Mon 01 Mar =C2=A0 =C2=A0 , Eli Dorfman (Voltaire) wrote:
>> We can add the trap generation to this patch.
>> what do you think?
>
> I think that if you need this feature than it should be implemented
> correctly (without assumptions that use can provide a "proper" files)=
,
> this should include some sort of connected client handling (in case i=
f
> its port disappear it could be disconnected for example).

We can verify local port is still available.

>
> For me it would seem more like topology "merge" rather then "reload"
> feature.

So if we call this option "merge" with local port validation this will
be acceptable?

Eli
>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
