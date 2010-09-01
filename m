From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RFC: Splitting of the management git tree in Open Fabrics
Date: Wed, 01 Sep 2010 09:15:07 +0300
Message-ID: <4C7DEF6B.80605@dev.mellanox.co.il>
References: <20100831125159.98e6d201.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100831125159.98e6d201.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/31/2010 10:51 PM, Ira Weiny wrote:
> As I briefly mentioned in an email to Yevgeny regarding libibumad ABI's; I
> believe it is time to break up the management git tree.
>
> With GA of OFED 1.5.2 scheduled for Sept 13, I would like to request comments
> from the community about the following split after that GA.
>
> On openfabrics.org/git split management.git into the following trees.
>
> openfabrics.org/git/infiniband-diags.git
> openfabrics.org/git/libibumad.git
> openfabrics.org/git/libibmad.git
> openfabrics.org/git/opensm.git
>
> Sasha can populate those from the current management tree.  We believe there
> are git commands which will do this without losing any history from the git
> trees.
>
> Vlad, what changes would you have to make in the OFED build to accommodate
> these packages being in separate git trees?
>

No changes will be required to the OFED build as all management packages are
taken as tarballs from http://www.openfabrics.org/downloads/management

Regards,
Vladimir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
