From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ibutils/ibdm/doc: Fix some typos
Date: Wed, 28 Oct 2009 14:18:53 +0200
Message-ID: <4AE836AD.5050406@dev.mellanox.co.il>
References: <20091016150640.GA21644@comcast.net>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091016150640.GA21644-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks, applied.

-- Yevgeny

Hal Rosenstock wrote:
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/ibdm/doc/ibdmchk.1 b/ibdm/doc/ibdmchk.1
> index 650c9ff..7537473 100644
> --- a/ibdm/doc/ibdmchk.1
> +++ b/ibdm/doc/ibdmchk.1
> @@ -186,7 +186,7 @@ Use enhanced routing algorithm when \s-1LMC\s0 > 0 and report the resulting path
>  .IX Item "-r|--roots <roots file> A file with all the roots node names (one on each line)."
>  .SH "VERIFICATION MODE DESCRIPTION"
>  .IX Header "VERIFICATION MODE DESCRIPTION"
> -After the cluster is built and OpenSM is run (using flag \-D 0x43) it reports the subnet and \s-1FDB\s0 tables into the files osm\-subnet.lst, osm.fdbs and osm.fdbs in /var/log/ (or subnet.lst, osm.fdbs and osm.mcfdbs into /tmp in older OpenSM versions). ibdiagnet is also producing the same files in its outoput directroy.
> +After the cluster is built and OpenSM is run (using flag \-D 0x43) it reports the subnet and \s-1FDB\s0 tables into the files osm\-subnet.lst, osm.fdbs and osm.fdbs in /var/log/ (or subnet.lst, osm.fdbs and osm.mcfdbs into /tmp in older OpenSM versions). ibdiagnet is also producing the same files in its output directory.
>  Based on these files the utility checks all \s-1CA\s0 to \s-1CA\s0 connectivity. Further analysis for credit deadlock potential is performed and reported.
>  In case of an \s-1LMC\s0 > 0 it reports histograms for how many systems and nodes are common between the different paths for the same port pairs.
>  .SH "ARGUMENTS"
> diff --git a/ibdm/doc/ibdmchk.pod b/ibdm/doc/ibdmchk.pod
> index e6a2232..dabfafa 100644
> --- a/ibdm/doc/ibdmchk.pod
> +++ b/ibdm/doc/ibdmchk.pod
> @@ -59,7 +59,7 @@ A file with all the roots node names (one on each line).
>  
>  =head1 VERIFICATION MODE DESCRIPTION
>  
> -After the cluster is built and OpenSM is run (using flag -D 0x43) it reports the subnet and FDB tables into the files osm-subnet.lst, osm.fdbs and osm.fdbs in /var/log/ (or subnet.lst, osm.fdbs and osm.mcfdbs into /tmp in older OpenSM versions). ibdiagnet is also producing the same files in its outoput directroy.
> +After the cluster is built and OpenSM is run (using flag -D 0x43) it reports the subnet and FDB tables into the files osm-subnet.lst, osm.fdbs and osm.fdbs in /var/log/ (or subnet.lst, osm.fdbs and osm.mcfdbs into /tmp in older OpenSM versions). ibdiagnet is also producing the same files in its output directory.
>  Based on these files the utility checks all CA to CA connectivity. Further analysis for credit deadlock potential is performed and reported.
>  In case of an LMC > 0 it reports histograms for how many systems and nodes are common between the different paths for the same port pairs.
>  
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
