From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/8 v2] Implement ODP using HMM v2
Date: Thu, 13 Aug 2015 15:20:45 -0400
Message-ID: <1439493653-1191-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kevin E Martin <kem-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Stoner, Greg" <Greg.Stoner-5C7GfCeVMHo@public.gmane.org>, "Bridgman, John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "Mantor, Michael" <Michael.Mantor-5C7GfCeVMHo@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Morichetti, Laurent" <Laurent.Morichetti-5C7GfCeVMHo@public.gmane.org>, Deucher, Alex
List-Id: linux-rdma@vger.kernel.org

Posting just for comment, still waiting on HMM to be accepted before
this patchset can be considered for inclusion.

This patchset implement the on demand paging feature using HMM. It
depends on the HMM patchset v10 (previous post (1)). Long term plan
is to replace ODP with HMM allowing to share same code infrastructure
accross different class of devices.

HMM (Heterogeneous Memory Management) is an helper layer for device
that want to mirror a process address space into their own mmu. Main
target is GPU but other hardware, like network device can take also
use HMM.

Tree with the patchset:
git://people.freedesktop.org/~glisse/linux hmm-v10 branch

(1) Previous patchset posting :
    v1 http://lwn.net/Articles/597289/
    v2 https://lkml.org/lkml/2014/6/12/559
    v3 https://lkml.org/lkml/2014/6/13/633
    v4 https://lkml.org/lkml/2014/8/29/423
    v5 https://lkml.org/lkml/2014/11/3/759
    v6 http://lwn.net/Articles/619737/
    v7 http://lwn.net/Articles/627316/
    v8 https://lwn.net/Articles/645515/
    v9 https://lwn.net/Articles/651553/

Cheers,
J=C3=A9r=C3=B4me

To: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
To: <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
Cc: "Kevin E Martin" <kem-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
Cc: "Christophe Harle" <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Duncan Poole" <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Sherry Cheung" <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Subhash Gutti" <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "John Hubbard" <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Mark Hairgrove" <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Lucien Dunning" <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Cameron Buschardt" <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Arvind Gopalakrishnan" <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
Cc: "Haggai Eran" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
Cc: "Or Gerlitz" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
Cc: "Sagi Grimberg" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Shachar Raindel" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
Cc: "Liran Liss" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
Cc: "Roland Dreier" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>,
Cc: "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>,
Cc: "Stoner, Greg" <Greg.Stoner-5C7GfCeVMHo@public.gmane.org>,
Cc: "Bridgman, John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>,
Cc: "Mantor, Michael" <Michael.Mantor-5C7GfCeVMHo@public.gmane.org>,
Cc: "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>,
Cc: "Morichetti, Laurent" <Laurent.Morichetti-5C7GfCeVMHo@public.gmane.org>,
Cc: "Deucher, Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>,
Cc: "Leonid Shamis" <Leonid.Shamis-5C7GfCeVMHo@public.gmane.org>,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
