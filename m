From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [Fwd: FW: OFED installation question re-AltLinux]
Date: Wed, 14 Oct 2009 14:28:03 +0200
Message-ID: <4AD5C3D3.1030409@dev.mellanox.co.il>
References: <4AD4ACBD.2000409@nasa.gov> <4AD57F03.1060807@dev.mellanox.co.il> <4AD5AD30.2000301@parallel.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD5AD30.2000301-bzQdu9zFT3Uox3rIn2DAYQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serg-bzQdu9zFT3Uox3rIn2DAYQ@public.gmane.org
Cc: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Sujal Das <sujal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jeffrey Scott <jeff-PQF7zMLV7HqjP/IhtLckvQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sergey Zhumatiy wrote:
>> Hi Sergey,
>> Try to add '--without-depcheck' to install.pl command:
>>
>> ./install.pl -c ofed.conf --without-depcheck
>>
>   In this case it fails on unistallation procedure. It seems, that some
> old dependency was forgotten or something like this. If this script can
> simply print in one line all packages needed to be uninstalled, then I
> could uninstall them manually, with other dependencies...
> 

See the reason of uninstall failure under /tmp/OFED.xxxx.logs

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
