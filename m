From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Mon, 11 Jan 2010 08:56:43 -0500
Message-ID: <f0e08f231001110556y7c47cc54oa3cfd5859f9a4e76@mail.gmail.com>
References: <20090813204306.dffc3237.weiny2@llnl.gov>
	 <20090816110200.GS25501@me> <20090817083023.da17378b.weiny2@llnl.gov>
	 <20090823120609.GG9547@me> <20090826164026.8dcce4b2.weiny2@llnl.gov>
	 <20091023234349.GK5764@me> <20091220121406.GF5262@me>
	 <20091220182809.f7e17fae.weiny2@llnl.gov> <20091221073550.GB18524@me>
	 <20091228092251.GR26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091228092251.GR26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Mon, Dec 28, 2009 at 4:22 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> Hi Ira,
>
> On 09:35 Mon 21 Dec =C2=A0 =C2=A0 , Sasha Khapyorsky wrote:
>>
>> An errors are response timeouts. I guess that most of them are due
>> to switches' VL15 overflow (could be verified by VL15Dropped counter
>> evaluation). Will look at this deeply.
>
> I did a couple of modifications in the code (exact log is listed belo=
w).
> In particular there are default limitation for number of outstanding =
MADs
> on the wire and proper tracking for failed (timedout) MADs. I tested
> this where possible. Could you re-run this? Thanks.
>
> Sasha
>

[snip...]

> commit da6aa19840cb2d37e8cd3daa3874b87657a76ddc
> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Date: =C2=A0 Fri Dec 25 16:24:13 2009 +0200
>
> =C2=A0 =C2=A0tests/subnet_discover: --maxsmps (-n) option
>
> =C2=A0 =C2=A0This implements the limitation of outstanding SMPs on a =
wire at any
> =C2=A0 =C2=A0one time. --maxsmps=3D0 means - no limit.
>
> =C2=A0 =C2=A0Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>
> diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
> index 7f8a85c..42e7aee 100644
> --- a/tests/subnet_discover.c
> +++ b/tests/subnet_discover.c
> @@ -40,6 +40,7 @@ static struct node *node_array[32 * 1024];
> =C2=A0static unsigned node_count =3D 0;
> =C2=A0static unsigned trid_cnt =3D 0;
> =C2=A0static unsigned outstanding =3D 0;
> +static unsigned max_outstanding =3D 8;

Any reason why this default is different from the one which OpenSM
uses ? Seems to me it should be the same (or less).

-- Hal

> =C2=A0static unsigned timeout =3D 100;
> =C2=A0static unsigned retries =3D 3;
> =C2=A0static unsigned verbose =3D 0;

[snip...]
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
