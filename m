From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC: Splitting of the management git tree in Open Fabrics
Date: Thu, 2 Sep 2010 16:36:34 -0400
Message-ID: <AANLkTimyyKEnFe3yuRBPzMp5Vx21PMyq=yJQMWyph3cu@mail.gmail.com>
References: <20100831125159.98e6d201.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100831125159.98e6d201.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ira,

On Tue, Aug 31, 2010 at 3:51 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> As I briefly mentioned in an email to Yevgeny regarding libibumad ABI=
's; I
> believe it is time to break up the management git tree.

I think these are separate issues. What are you trying to achieve by
doing this ?

-- Hal

> With GA of OFED 1.5.2 scheduled for Sept 13, I would like to request =
comments
> from the community about the following split after that GA.
>
> On openfabrics.org/git split management.git into the following trees.
>
> openfabrics.org/git/infiniband-diags.git
> openfabrics.org/git/libibumad.git
> openfabrics.org/git/libibmad.git
> openfabrics.org/git/opensm.git
>
> Sasha can populate those from the current management tree. =C2=A0We b=
elieve there
> are git commands which will do this without losing any history from t=
he git
> trees.
>
> Vlad, what changes would you have to make in the OFED build to accomm=
odate
> these packages being in separate git trees?
>
> Any other concerns or comments?
>
> Thanks,
> Ira
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
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
