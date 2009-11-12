From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: saquery on ibsim
Date: Thu, 12 Nov 2009 08:34:32 -0500
Message-ID: <f0e08f230911120534m4590af25h41063d9f69e4bd14@mail.gmail.com>
References: <829ded920911120500j36749e9fpef51e5021949a778@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <829ded920911120500j36749e9fpef51e5021949a778-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2009 at 8:00 AM, Keshetti Mahesh
<keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I am observing difference in behavior of 'saquery' on real cluster an=
d
> ibsim. Whenever I query for path records on cluster using
>
> #saquery -p
>
> it returns path records of all possible source-destination combinatio=
n.
> But when I run the same command on a simulated cluster (ibsim) it
> returns only 2-3 path records even though there are many nodes(> 25).
>
> Is there any limitation in ibsim which is not letting the saquery pro=
gram
> retrieve all path records available ?

ibsim does not support RMPP.

-- Hal

>
> --
> Keshetti Mahesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
