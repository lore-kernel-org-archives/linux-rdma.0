From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [Fwd: FW: OFED installation question re-AltLinux]
Date: Wed, 14 Oct 2009 09:34:27 +0200
Message-ID: <4AD57F03.1060807@dev.mellanox.co.il>
References: <4AD4ACBD.2000409@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD4ACBD.2000409-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serg-bzQdu9zFT3Uox3rIn2DAYQ@public.gmane.org
Cc: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Sujal Das <sujal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jeffrey Scott <jeff-PQF7zMLV7HqjP/IhtLckvQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
Try to add '--without-depcheck' to install.pl command:

./install.pl -c ofed.conf --without-depcheck

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
