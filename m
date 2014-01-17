From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Fri, 17 Jan 2014 17:02:49 -0500
Message-ID: <yq1d2jquv06.fsf@sermon.lab.mkp.net>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	<CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	<52CD1C68.4050406@mellanox.com>
	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389906852.5567.668.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
	(Nicholas A. Bellinger's message of "Thu, 16 Jan 2014 13:14:12 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> writes:

nab> So there is not a interface in SCSI land for interacting (directly)
nab> with hardware protection support, as it's primarily just telling
nab> SCSI what protection modes are supported while the rest is
nab> implemented in vendor specific firmware interfaces.  (CC'ing MKP)

I've worked on getting my DIX1.1 changes ready for submission the last
couple of days. That'll take the magic out of firmware and into the SCSI
stack.

I'll get those patches out early next week. They are fairly trivial but
do require some changes to mptNsas, lpfc and qla2xxx.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
