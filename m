From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: IPoIB GRO
Date: Mon, 4 Nov 2013 08:40:01 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>,<527759C6.3070009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-b04fa503-5e9d-499b-a579-9720aced2a77"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527759C6.3070009-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-b04fa503-5e9d-499b-a579-9720aced2a77
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Erez,=0A=
=0A=
> don't you see that behaviour in tcpdump? what kernel are you using?=0A=
=0A=
On server side we have a 3.5 on client side a 3.11 kernel each of them with=
=0A=
kernel standard drivers/modules. I can see the same pattern of GRO =0A=
aggregation on the client that you mention but only if I disable TSO for =
=0A=
ib0 on the server side. =0A=
=0A=
The test I'm running on the client is like this. The second and third read=
=0A=
run are definetly served by the NFS server side cache.=0A=
=0A=
sysctl -w net.ipv4.tcp_mem=3D"4096 65536 4194304"=0A=
sysctl -w net.ipv4.tcp_rmem=3D"4096 65536 4194304"=0A=
sysctl -w net.ipv4.tcp_wmem=3D"4096 65536 4194304"=0A=
sysctl -w net.core.rmem_max=3D8388608=0A=
sysctl -w net.core.wmem_max=3D8388608=0A=
=0A=
mount -o nfsvers=3D3,rsize=3D262144,wsize=3D262144 10.10.30.251:/export /mn=
t=0A=
echo 3 > /proc/sys/vm/drop_caches=0A=
dd if=3D/mnt/xxx.iso of=3D/dev/null bs=3D1M count=3D5000=0A=
echo 3 > /proc/sys/vm/drop_caches=0A=
dd if=3D/mnt/xxx.iso of=3D/dev/null bs=3D1M count=3D5000=0A=
echo 3 > /proc/sys/vm/drop_caches=0A=
dd if=3D/mnt/xxx.iso of=3D/dev/null bs=3D1M count=3D5000=0A=
umount /mnt=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-b04fa503-5e9d-499b-a579-9720aced2a77
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-b04fa503-5e9d-499b-a579-9720aced2a77--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
