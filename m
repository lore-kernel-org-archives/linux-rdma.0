From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] dapltest-server segfault seen on recent OFED-1.5.4 daily
 build
Date: Tue, 22 Nov 2011 12:41:19 +0530
Message-ID: <4ECB4B17.20407@chelsio.com>
References: <20111118090155.GB17346@kumars-PC.asicdesigners.com> <54347E5A035A054EAE9D05927FB467F916EA49A5@ORSMSX101.amr.corp.intel.com> <4ECA3402.8030203@chelsio.com> <54347E5A035A054EAE9D05927FB467F916EA4CE2@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070801060903090400020107"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54347E5A035A054EAE9D05927FB467F916EA4CE2-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070801060903090400020107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Arlin,

On 11/22/2011 01:51 AM, Davis, Arlin R wrote:
> Can you send me your scripts so I can attempt to duplicate?
Find attached the script with this mail.

> Did this test setup run successfully before OFED 1.5.4 RC3 release?
I am not sure when it stopped working.
However, we have been running this script on dapl for quite some time, 
and it used to work fine earlier.


Thanks,
Kumar.

--------------070801060903090400020107
Content-Type: text/plain;
 name="dapltest_stress_bug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dapltest_stress_bug.txt"

#!/bin/sh

host=$1
device=$2

while [ 1 ]
do
i=$(( i+1 ))
#====================================================================
#test1
#====================================================================
dapltest -T T -s ${host} -D ${device} -i 100000 -t 1 -w 1 \
	client SR 256 					   \
	server SR 256

#====================================================================
#test2
#====================================================================
dapltest -T T -s ${host} -D ${device} -i 100000 -t 1 -w 1 \
	client SR 256 					   \
	server RW 4096 					   \
	server SR 256

#====================================================================
#test3
#====================================================================
dapltest -T T -s ${host} -D ${device} -i 100000 -t 1 -w 1 \
	client SR 256 					   \
	server RR 4096 					   \
	server SR 256

#====================================================================
#test4
#====================================================================
dapltest -T T -s ${host} -D ${device} -i 100000 -t 1 -w 1 \
	client SR 256 					   \
	server RW 4096 					   \
	server SR 256 					   \
	client SR 256 					   \
	server RW 4096 					   \
	server SR 256 					   \
	client SR 4096 					   \
	server SR 256
 
#====================================================================
#test5
#====================================================================
dapltest -T T -s ${host} -D ${device} -i 100000 -t 1 -w 8 \
	client SR 256 					   \
	server RW 4096 					   \
	server SR 256 					   \
	client SR 256 					   \
	server RW 4096 					   \
	server SR 256 					   \
	client SR 4096 					   \
	server SR 256
 
#====================================================================
#test6
#====================================================================
dapltest -T T -s ${host} -D ${device} -i 100000 -t 4 -w 8 \
	client SR 256 					   \
	server RW 4096 					   \
	server SR 256 					   \
	client SR 256 					   \
	server RW 4096 					   \
	server SR 256 					   \
	client SR 4096 					   \
	server SR 256

wait
echo "Iteration $i"
sleep 10
done

--------------070801060903090400020107--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
