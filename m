From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Tue, 15 Nov 2011 11:59:47 +0200
Message-ID: <4EC23813.2010401@dev.mellanox.co.il>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il> <1321183221.65654.YahooMailNeo@web24703.mail.ird.yahoo.com> <4EC0D87E.6090203@dev.mellanox.co.il> <1321290618.98338.YahooMailNeo@web24709.mail.ird.yahoo.com> <1321305022.98364.YahooMailNeo@web24703.mail.ird.yahoo.com> <1321310529.30932.YahooMailNeo@web24708.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321310529.30932.YahooMailNeo-7VlcqDaCG9fyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/15/2011 12:42 AM, Lukas Razik wrote:
>> Hello again, Vladimir!
>
>>
>> To set up "/dev/mst/mt25418_pci_cr0" manually I've followed up
>> what "/etc/init.d/mst start" does.
>> I've seen that it uses the "minit" tool which is part of the arch
>> dependent mft-package.
>>
>> Is there maybe a possibility to get "minit" for sparc64?
>> Otherwise I can't init "/dev/mst/mt25418_pci_cr0"... :-(
>>
>
> Oh, I'm sorry! I've read this file from Mellanox:
> http://www.mellanox.com/pdf/MFT/MFT_user_manual.pdf
> which I've found here:
> http://www.mellanox.com/content/pages.php?pg=management_tools&menu_section=34
> where the firmware flashing procedure is described for flint.
>
> And I thought flint == mstflint because mstflint shows it's flint:
> # mstflint
>              FLINT - FLash INTerface
> SYNOPSIS
>      flint [switches...]<command>  [parameters...]
>
> Now I've seen that I don't need "/dev/mst/mt25418_pci_cr0" for mstflint.
> So if I want to burn a firmware on the adapter I only have to write:
> mstflint -d 12:00.0 -i fw.bin burn
> Will the guid and the mac stay the same as before?
>
> A big sorry again!
>
> Regards,
> Lukas
>

Hi Lukas,
GUID and MAC will stay the same as before.

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
