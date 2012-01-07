From: pierre orzechowski <pierre.e.orzechowski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: ibswitches command displays wrong information when switch description
 string includes "base"
Date: Fri, 06 Jan 2012 16:22:32 -0800
Message-ID: <4F079048.8050709@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

We have a customer reporting an issue with the "ibswitches" command part 
of the infiniband-diags package.
If the switch description includes the string "base" anywhere, then the 
match operation in the awk section of ibwitches does not behave as 
expected and output is garbled.

Example :

[root@slcc09sw-ib2 tmp]# grep Switch ibnetdisc.out
Switch  36 "S-002128468ee1a0a0"         # "SUN DCS 36P QDR basesw-ib3 
10.242.48.23" enhanced port 0 lid 1 lmc 0
Switch  36 "S-0021286cc8a3a0a0"         # "SUN DCS 46P QDR slcc09sw-ib3 
10.242.48.24" enhanced port 0 lid 12 lmc 0
[root@slcc09sw-ib2 tmp]# ibswitches ibnetdisc.out
Switch  : 0x002128468ee1a0a0 ports 36 "SUN DCS 36P QDR base port 0 lid 1 
lmc 0
Switch  : 0x0021286cc8a3a0a0 ports 36 "SUN DCS 46P QDR slcc09sw-ib3 
10.242.48.24" enhanced port 0 lid 12 lmc 0

The 1 liner workaround we have is to replace in red :
echo "$text" | awk '
/^Switch/       {
                         l=$0
                         desc=substr(l, match(l, "#[ \t]*")+RLENGTH)
                         pi=match(desc, "port 0.*")
                         pinfo=substr(desc, pi)
                         desc=substr(desc, 1, pi-2)
type="base"
                         ti=match(desc, type)
...

With

echo "$text" | awk '
/^Switch/       {
                         l=$0
                         desc=substr(l, match(l, "#[ \t]*")+RLENGTH)
                         pi=match(desc, "port 0.*")
                         pinfo=substr(desc, pi)
                         desc=substr(desc, 1, pi-2)
type="\base\"
                         ti=match(desc, type)
...

Thanks for your help in reviewing this potential defect.
Apologies if posting to the wrong mailing list.

Best regards,
Pierre Orzechowski

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
