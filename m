From: Guy Coates <gmpc-5fLPn3lgkryFxr2TtlUqVg@public.gmane.org>
Subject: Re: [Fwd: FW: OFED installation question re-AltLinux]
Date: Tue, 13 Oct 2009 19:10:09 +0100
Message-ID: <4AD4C281.6060009@sanger.ac.uk>
References: <4AD4ACBD.2000409@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD4ACBD.2000409-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serg-bzQdu9zFT3Uox3rIn2DAYQ@public.gmane.org
Cc: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Sujal Das <sujal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jeffrey Scott <jeff-PQF7zMLV7HqjP/IhtLckvQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jeff Becker wrote:
> Forwarding... Please reply to Sergey (cc'd above). Thanks.
> 
> -jeff
> 
> P.S. The general list does not accept messages anymore - the archives
> are still available.
> 
> -------- Original Message --------
> Subject: 	FW: OFED installation question re-AltLinux
> Date: 	Tue, 13 Oct 2009 11:14:08 -0500
> From: 	Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
> Reply-To: 	bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
> To: 	general-owner-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> <general-owner-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
> CC: 	'Jeffrey Scott' <jeff-PQF7zMLV7HqjP/IhtLckvQ@public.gmane.org>, 'Sujal Das'
> <sujal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> 
> 
> If some one on general knows how to help Serg who sent the message below,
> please respond. Thank you.
> 
> Bill Boas
> VP, Bus Dev System Fabric Works
> Exec Dir. OpenFabrics Alliance
> 510-375-8840
> bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
> www.systemfabricworks.com
> bill.boas-G2znmakfqn7U1rindQTSdQ@public.gmane.org
> www.openfabrics.org
> 
> 
> -----Original Message-----
> From: Jeffrey Scott [mailto:jeff-PQF7zMLV7HqjP/IhtLckvQ@public.gmane.org] 
> Sent: Tuesday, October 13, 2009 9:09 AM
> To: bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org; 'Sujal Das'
> Subject: FW: OFED installation
> 
> Who should this inquiry go to?
> 
> 
> -----Original Message-----
> From: Sergey Zhumatiy [mailto:serg-bzQdu9zFT3Uox3rIn2DAYQ@public.gmane.org] 
> Sent: Tuesday, October 13, 2009 2:44 AM
> To: membership-G2znmakfqn7U1rindQTSdQ@public.gmane.org; webmaster-G2znmakfqn7U1rindQTSdQ@public.gmane.org
> Subject: OFED installation
> 
>   Hello!
>   I try to install OFED-1.5 on my AltLinux cluster. AltLinux is
> rpm-based, but I cannot install it because install .pl cannot find gcc,
> stdc++-devel and tk. All of them are installed. OFED-1.0.1 was installed
> succesfully one year ago.
>   How can I compile and install latest OFED?
> 
>   Also, I want to install latest OFED to my experimental Debian cluster.
> Is it possible?
> 
>   Thank you.
> 
Hi Sergey,


OFED debian packages (up to OFED 1.4.2) are available here:

http://pkg-ofed.alioth.debian.org/

Cheers,

Guy

-- 
Dr Guy Coates,  Informatics System Group
The Wellcome Trust Sanger Institute, Hinxton, Cambridge, CB10 1HH, UK
Tel: +44 (0)1223 834244 ex 6925
Fax: +44 (0)1223 496802


-- 
 The Wellcome Trust Sanger Institute is operated by Genome Research 
 Limited, a charity registered in England with number 1021457 and a 
 company registered in England with number 2742969, whose registered 
 office is 215 Euston Road, London, NW1 2BE. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
