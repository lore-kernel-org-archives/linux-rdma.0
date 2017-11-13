From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 16:02:26 +0100
Message-ID: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-uk2M96/98Pc@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

After looking into the ML, here are the candidates for the stable-v15 branch.
Can the authors please confirm that they should be applied there ?

Please let me know if I missed any.

Nicolas

---

Devesh Sharma (1):
      bnxt_re/lib: increment psn in case of 0 length packets

Hal Rosenstock (1):
      libibumad/umad.c: In get_port, ignore sysfs rate file errors

Jason Gunthorpe (1):
      verbs: Do not block QP attr_masks used by older kernels

Michael J. Ruhl (2):
      ibacm: Incorrect usage of BE byte order of MLID attach/detach_mcast()
      ibacm: Incorrect list used for subnet list causes a segfault

Ram Amrani (1):
      libqedr: fix inline data copy


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
