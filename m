From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: OFA management tree seperation
Date: Sun, 13 Feb 2011 09:55:50 +0200
Message-ID: <20110213075550.GB5697@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


We finished the management tree seperation.
>From now on, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> takes the responsibility for maitaining libibmad and
infiniband-diags. His trees are:

    git://git.openfabrics.org/~iraweiny/libibmad
    git://git.openfabrics.org/~iraweiny/infiniband-diags

libibumad, opensm and ibsim trees stays under my responsibility:

    git://git.openfabrics.org/~alexnetes/libibumad
    git://git.openfabrics.org/~alexnetes/opensm
    git://git.openfabrics.org/~alexnetes/ibsim


Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
