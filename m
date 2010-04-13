From: Justin Clift <justin-oNuxUQfTmABg9hUCZPvPmw@public.gmane.org>
Subject: Weird board ID
Date: Tue, 13 Apr 2010 18:37:55 +1000
Message-ID: <4BC42D63.5050505@salasaga.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

Just received an old Topspin 2 port PCIe card (MTLP25208-C), using=20
firmware 4.6.0 and thought I'd update it to the latest firmware before=20
trying to do anything with it.

However, the board id is being reported really strangely:

   $ sudo mstflint -d mthca0 q
   Image type:      Failsafe
   I.S. Version:    1
   Chip Revision:   A0
   Description:     Node             Port1            Port2=20
Sys image
   GUIDs:           0005ad00000467fc 0005ad00000467fd 0005ad00000467fe=20
0005ad00000467ff
   Board ID:        q=EF=BF=BD=EF=BF=BD=03
   VSD:             q=EF=BF=BD=EF=BF=BD=03
   PSID:
   $

Does anyone know what that's about?

Was considering the firmware on the board may be stuffed, but it seems=20
to be verifying ok:

   $ sudo mstflint -d mthca0 v

   Failsafe image:

   Invariant     /0x00000028-0x0000095f (0x000938)/ (BOOT2) - OK

   Primary Image /0x00010000-0x00010107 (0x000108)/ (Pointer Sector)- O=
K
                 /0x00030028-0x000308af (0x000888)/ (BOOT2) - OK
                 /0x000308b0-0x000348df (0x004030)/ (BOOT2) - OK
                 /0x000348e0-0x00036bd3 (0x0022f4)/ (Configuration) - O=
K
                 /0x00036bd4-0x00036c07 (0x000034)/ (GUID) - OK
                 /0x00036c08-0x0004452f (0x00d928)/ (DDR) - OK
                 /0x00044530-0x0004c97b (0x00844c)/ (DDR) - OK
                 /0x0004c97c-0x000617a3 (0x014e28)/ (DDR) - OK
                 /0x000617a4-0x00074813 (0x013070)/ (DDR) - OK
                 /0x00074814-0x00077883 (0x003070)/ (DDR) - OK
                 /0x00077884-0x00078f37 (0x0016b4)/ (DDR) - OK
                 /0x00078f38-0x00078f4b (0x000014)/ (Configuration) - O=
K
                 /0x00078f4c-0x00078f8f (0x000044)/ (Jump addresses) - =
OK
                 /0x00078f90-0x00082bf3 (0x009c64)/ (EMT Service) - OK

   Secondary Image /0x00020000-0x00020107 (0x000108)/ (Pointer Sector)-=
 OK
                 /0x00090028-0x000908af (0x000888)/ (BOOT2) - OK
                 /0x000908b0-0x000948df (0x004030)/ (BOOT2) - OK
                 /0x000948e0-0x00096bd3 (0x0022f4)/ (Configuration) - O=
K
                 /0x00096bd4-0x00096c07 (0x000034)/ (GUID) - OK
                 /0x00096c08-0x000a452f (0x00d928)/ (DDR) - OK
                 /0x000a4530-0x000ac97b (0x00844c)/ (DDR) - OK
                 /0x000ac97c-0x000c17a3 (0x014e28)/ (DDR) - OK
                 /0x000c17a4-0x000d4813 (0x013070)/ (DDR) - OK
                 /0x000d4814-0x000d7883 (0x003070)/ (DDR) - OK
                 /0x000d7884-0x000d8f37 (0x0016b4)/ (DDR) - OK
                 /0x000d8f38-0x000d8f4b (0x000014)/ (Configuration) - O=
K
                 /0x000d8f4c-0x000d8f8f (0x000044)/ (Jump addresses) - =
OK
                 /0x000d8f90-0x000e2bf3 (0x009c64)/ (EMT Service) - OK

   FW image verification succeeded. Image is bootable.

   $

*********************

This is interesting too (hopefully the correct firmware image).  Not=20
that it's not extracting a correct firmware version number?

   $ sudo mstflint -d mthca0 -i fw-25208-4_8_200-MHEL-CF128-T.bin -nofs=
 b

       Current FW version on flash:  N/A
       New FW version:               N/A

   Burn process will not be failsafe. No checks will be performed.
   ALL flash, including the Invariant Sector will be overwritten.
   If this process fails, computer may remain in an inoperable state.

    Do you want to continue ? (y/n) [n] : n
   $

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
